class Experts::ReservableFrameRegisterService < Users::ReserveRegisterService
  # 年月日をキーとした予約可能枠の可否のハッシュを返す
  # @return  Hash:{
  #   YYYY-MM-DD => [
  #     {
  #       "datetime" => <Time>, "registered" => <bool>, "reserved" => <bool>,
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
                          .select(:start_at)
                          .group(:start_at)
                          .where(start_at: start_frame..last_frame)
                          .where(expert_id: @expert_id)
    reserves = Reserve
                 .select(:start_at)
                 .where(start_at: start_frame..last_frame)
                 .where(expert_id: @expert_id)
    @schedules = {}
    dates.each { |k, v|
      v.each { |date|
        label = date['date'].strftime("%Y-%m-%d")
        @schedules[label] = []
        frames.each { |frame|
          target_frame = date['date'].to_time.since(frame.strftime('%H').to_i.hours).since(frame.strftime('%M').to_i.minutes)

          reservable = true
          # 土曜日の予約枠の範囲内チェック
          if date['date'].wday == 6 && !@reserve_frame.verifyFrameSaturday(target_frame)
            reservable = false
          end
          # 日曜日の予約枠の範囲内チェック
          if date['date'].wday == 0 && !@reserve_frame.verifyFrameHoliday(target_frame)
            reservable = false
          end
          # 祝日の予約枠の範囲内チェック
          if HolidayJapan.check(date['date']) && !@reserve_frame.verifyFrameHoliday(target_frame)
            reservable = false
          end

          registered = reservable_frames.find { |reservable_frame| reservable_frame.start_at.to_i == target_frame.to_i } ? true : false
          reserved = reserves.find { |reserve| reserve.start_at.to_i == target_frame.to_i } ? true : false
          @schedules[label].push({"datetime" => target_frame,
                                  "registered" => registered,
                                  "reserved" => reserved,
                                  "reservable" => reservable
                                 })
        }
      }
    }
    @schedules
  end

  # 既にユーザーから予約されている日時が送られてきていないかを検証
  # 日時が予約可能枠として登録できるものなのかを検証
  # @return boolean
  def verifyReservableFrames(reservable_frames)
    keys = []
    reservable_frames.each do |k, v|
      # 土曜日の予約枠の範囲内チェック
      if k.to_date.wday == 6 && !@reserve_frame.verifyFrameSaturday(k.to_time)
        return false
      end
      # 日曜日の予約枠の範囲内チェック
      if k.to_date.wday == 0 && !@reserve_frame.verifyFrameHoliday(k.to_time)
        return false
      end
      # 祝日の予約枠の範囲内チェック
      if HolidayJapan.check(k.to_date) && !@reserve_frame.verifyFrameHoliday(k.to_time)
        return false
      end
      # 平日の予約枠の範囲内チェック
      if !@reserve_frame.verifyFrameWeekday(k.to_time)
        return false
      end
      keys.push(k)
    end
    # 予約登録が既にされているかをチェック
    Reserve.where(expert_id: @expert_id, start_at: keys).empty?
  end

  def reservableFramesRegister(reservable_frames)
    ActiveRecord::Base.transaction do
      start_frame = getStartFrame
      last_frame = getLastFrame
      ReservableFrame
        .delete_by(start_at: start_frame..last_frame, expert_id: @expert_id)
      reservable_frames.each do |k, v|
        if v == "1"
          record = ReservableFrame.find_or_create_by(
            expert_id: @expert_id,
            start_at: k.to_time
          )
          record.save
        end
      end
    end
  end
end
