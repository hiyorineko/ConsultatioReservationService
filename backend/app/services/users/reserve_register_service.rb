class Users::ReserveRegisterService
  def initialize(
    page = nil,
    expert_id = nil,
    datetime = nil,
    user_comment = nil,
    expert_type_id = nil
  )
    if page
      @page = page.to_i
    else
      @page = 1
    end
    if expert_id
      @expert_id = expert_id.to_i
    end
    @datetime = datetime
    @user_comment = user_comment
    @reserve_frame = ReserveFrame.new
    @expert_type_id = expert_type_id.to_i
  end

  # 年月をキーとした日にちと曜日のHashを取得
  #
  # @return Hash:{
  #   YYYY年MM月 => [
  #     {"date" => Date, "day" => "(日)"},
  #     {"date" => Date, "day" => "(月)"},...
  #   ],...
  # }
  def getDates
    days = %w[(日) (月) (火) (水) (木) (金) (土)]
    @dates = {}
    (getStartDate..getLastDate).each { | date |
      label = date.strftime("%Y年%m月")
      if @dates[label] == nil
        @dates[label] = []
      end
      @dates[label].push({"date" => date  , "day" => days[date.wday]})
    }
    @dates
  end

  # 年月日をキーとした予約可否のハッシュを返す
  # @return  Hash:{
  #   YYYY-MM-DD => [
  #     {
  #       "datetime" => <Time>, "reservable" => <bool>,
  #     }...
  #   ],...
  # }
  #
  def getReservableFrames
    dates = getDates
    frames = getReserveFrames

    start_frame = getStartFrame
    last_frame = getLastFrame

    reservable_frames = ReservableFrame
                          .joins(:expert)
                          .select(:start_at)
                          .group(:start_at)
                          .where(start_at: start_frame..last_frame)
                          .where(expert: { expert_type_id: @expert_type_id })
    if @expert_id
      reservable_frames = reservable_frames.where(expert_id: @expert_id)
    end
    @schedules = {}
    dates.each { |k, v|
      v.each { |date|
        label = date['date'].strftime("%Y-%m-%d")
        @schedules[label] = []
        frames.each { |frame|
          target_frame = date['date'].to_time.since(frame.strftime('%H').to_i.hours).since(frame.strftime('%M').to_i.minutes)

          # 土曜日の予約枠の範囲内チェック
          if date['date'].wday == 6 && !@reserve_frame.verifyFrameSaturday(target_frame)
            @schedules[label].push({"datetime" => target_frame, "reservable" => false})
            next
          end

          # 日曜日の予約枠の範囲内チェック
          if date['date'].wday == 0 && !@reserve_frame.verifyFrameHoliday(target_frame)
            @schedules[label].push({"datetime" => target_frame, "reservable" => false})
            next
          end

          # 祝日の予約枠の範囲内チェック
          if HolidayJapan.check(date['date']) && !@reserve_frame.verifyFrameHoliday(target_frame)
            @schedules[label].push({"datetime" => target_frame, "reservable" => false})
            next
          end

          if reservable_frames.find { |reservable_frame| reservable_frame.start_at.to_i == target_frame.to_i }
            @schedules[label].push({"datetime" => target_frame, "reservable" => true})
          else
            @schedules[label].push({"datetime" => target_frame, "reservable" => false})
          end
        }
      }
    }
    @schedules
  end

  # 画面表示する予約枠一覧の開始日を取得
  # @return Date
  def getStartDate
    Date.today + (14 * (@page - 1))
  end

  # 画面表示する予約枠一覧の最後の日を取得
  # @return Date
  def getLastDate
    getStartDate + 13
  end

  # 画面表示する予約枠一覧の最初の日時を取得
  # @return Time
  def getStartFrame
    getStartDate.to_time + (60 * 60 * @reserve_frame.getFirstFrameHour) + (60 * @reserve_frame.getFirstFrameMinute)
  end

  # 画面表示する予約枠一覧の最後の日時を取得
  # @return Time
  def getLastFrame
    getLastDate.to_time + (60 * 60 * @reserve_frame.getLastFrameHour) + (60 * @reserve_frame.getLastFrameMinute)
  end

  # 予約枠の配列を取得
  # @return Array<Date>
  #
  def getReserveFrames
    frame_start_time = @reserve_frame.getFirstFrameTime
    frame_last_time = @reserve_frame.getLastFrameTime
    frame_unit_minute = @reserve_frame.getFrameUnitMinute

    @frames = []
    @frames.push(frame_start_time)
    while @frames.last + frame_unit_minute.minutes <= frame_last_time do
      @frames.push(@frames.last + frame_unit_minute.minutes)
    end
    @frames
  end

  # 表示するページ番号の取得
  def getParamPage
    @page
  end

  # 選択されたエキスパートの取得
  def getParamExpertId
    @expert_id
  end

  # 選択されたエキスパートの取得
  # @return Expert
  def getExpert
    Expert.find_by(id: @expert_id)
  end

  # 選択された種別のエキスパートの取得
  # @return ActiveRecord::Relation<Expert>
  def getExperts
    Expert.where(expert_type_id: @expert_type_id)
  end

  # Reserveを登録
  # @return void
  def reserveRegister(user_id)
    ActiveRecord::Base.transaction do
      # ReservableFrameを取得
      if @expert_id.nil?
        # エキスパート指定あり
        reservable_frame = ReservableFrame.find_by!(expert_id: @expert_id, start_at: @datetime)
      else
        # 指定無し
        reservable_frame = ReservableFrame.find_by!(start_at: @datetime)
      end

      ## 予約を登録
      reserve = Reserve.new(user_id: user_id,
                         expert_id: reservable_frame.expert_id,
                         start_at: reservable_frame.start_at,
                         user_comment: @user_comment)
      if reserve.save
        ## 予約可能枠を削除
        reservable_frame.destroy
      end

      user = User.find(reserve.user_id)
      expert = Expert.find(reserve.expert_id)
      expert_type = ExpertType.find(expert.expert_type_id)

      ## 予約登録の通知
      ReserveRegisterMailer.send_reserve_complete_email_to_user(reserve, user, expert, expert_type).deliver
      ReserveRegisterMailer.send_reserve_complete_email_to_expert(reserve, user, expert_type).deliver
    end
  end

  def getParamDateTime
    @datetime
  end

  def getAllExpertTypes
    ExpertType.all
  end

  def getParamExpertTypeId
    @expert_type_id
  end

  def getExpertType
    ExpertType.find(@expert_type_id)
  end
end
