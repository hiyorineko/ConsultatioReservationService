class ReserveFrame
  include ActiveModel::AttributeMethods
  FIRST_FRAME_HOUR = 10
  FIRST_FRAME_MINUTE = 0
  LAST_FRAME_HOUR = 18
  LAST_FRAME_MINUTE = 0
  FRAME_UNIT_MINUTE = 30

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
