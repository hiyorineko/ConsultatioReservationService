class ReserveFrame
  include ActiveModel::AttributeMethods
  FIRST_FRAME_HOUR = 10
  FIRST_FRAME_MINUTE = 0
  LAST_FRAME_HOUR = 18
  LAST_FRAME_MINUTE = 0
  FRAME_UNIT_MINUTE = 30
  RESERVABLE_SATURDAY = true
  SATURDAY_FIRST_FRAME_HOUR = 11
  SATURDAY_FIRST_FRAME_MINUTE = 0
  SATURDAY_LAST_FRAME_HOUR = 15
  SATURDAY_LAST_FRAME_MINUTE = 0
  RESERVABLE_HOLIDAY = false
  HOLIDAY_FIRST_FRAME_HOUR = 0
  HOLIDAY_FIRST_FRAME_MINUTE = 0
  HOLIDAY_LAST_FRAME_HOUR = 0
  HOLIDAY_LAST_FRAME_MINUTE = 0

  # 1日の最初の予約枠の時間を取得
  # @return Time
  def getFirstFrameTime
    Time.current.change(hour: FIRST_FRAME_HOUR).change(min:FIRST_FRAME_MINUTE)
  end

  # 1日の最後の予約枠の時間を取得
  # @return Time
  def getLastFrameTime
    Time.current.change(hour: LAST_FRAME_HOUR).change(min:LAST_FRAME_MINUTE)
  end

  # 平日の予約枠の範囲内かどうかを調べる
  #
  # @param time Time
  # @return boolean
  def verifyFrameWeekday(time)
    start_day = time.midnight.change(hour: FIRST_FRAME_HOUR).change(min: FIRST_FRAME_MINUTE)
    end_day = time.midnight.change(hour: LAST_FRAME_HOUR).change(min: LAST_FRAME_MINUTE)
    time.between?(start_day, end_day)
  end

  # 土曜日の予約枠の範囲内かどうかを調べる
  #
  # @param time Time
  # @return boolean
  def verifyFrameSaturday(time)
    if RESERVABLE_SATURDAY
      start_day = time.midnight.change(hour: SATURDAY_FIRST_FRAME_HOUR).change(min: SATURDAY_FIRST_FRAME_MINUTE)
      end_day = time.midnight.change(hour: SATURDAY_LAST_FRAME_HOUR).change(min: SATURDAY_LAST_FRAME_MINUTE)
      time.between?(start_day, end_day)
    else
      false
    end
  end

  def verifyFrameHoliday(time)
    if RESERVABLE_HOLIDAY
      start_day = time.midnight.change(hour: HOLIDAY_FIRST_FRAME_HOUR).change(min: HOLIDAY_FIRST_FRAME_MINUTE)
      end_day = time.midnight.change(hour: HOLIDAY_LAST_FRAME_HOUR).change(min: HOLIDAY_LAST_FRAME_MINUTE)
      time.between?(start_day, end_day)
    else
      false
    end
  end

  def getFirstFrameHour
    FIRST_FRAME_HOUR
  end
  def getFirstFrameMinute
    FIRST_FRAME_MINUTE
  end
  def getLastFrameHour
    LAST_FRAME_HOUR
  end
  def getLastFrameMinute
    LAST_FRAME_MINUTE
  end

  # 予約枠の単位（分）を取得
  # @return Integer
  def getFrameUnitMinute
    FRAME_UNIT_MINUTE
  end

end
