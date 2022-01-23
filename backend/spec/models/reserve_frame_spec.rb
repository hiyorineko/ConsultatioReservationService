require 'rails_helper'


RSpec.describe ReserveFrame do
  describe "正常系" do
    before do
      @reserve_frame = ReserveFrame.new
    end
    around do |e|
      # 日付を固定
      travel_to('2022-1-20 12:00'.to_time) {e.run}
    end
    it "verifyFrameWeekday" do
      # 平日の予約枠の範囲外
      test_time1 = '2022-1-20 09:59'.to_time
      # 平日の予約枠の範囲内
      test_time2 = '2022-1-20 10:00'.to_time
      test_time3 = '2022-1-20 12:00'.to_time
      test_time4 = '2022-1-20 17:30'.to_time
      # 平日の予約枠の範囲内
      test_time5 = '2022-1-20 17:31'.to_time
      expect(@reserve_frame.verifyFrameWeekday(test_time1)).to eq false
      expect(@reserve_frame.verifyFrameWeekday(test_time2)).to eq true
      expect(@reserve_frame.verifyFrameWeekday(test_time3)).to eq true
      expect(@reserve_frame.verifyFrameWeekday(test_time4)).to eq true
      expect(@reserve_frame.verifyFrameWeekday(test_time5)).to eq false
    end
    it "verifyFrameSaturday" do
      # 土曜日の予約枠の範囲外
      test_time1 = '2022-1-20 10:59'.to_time
      # 土曜日の予約枠の範囲内
      test_time2 = '2022-1-20 11:00'.to_time
      test_time3 = '2022-1-20 14:59'.to_time
      test_time4 = '2022-1-20 15:00'.to_time
      # 土曜日の予約枠の範囲外
      test_time5 = '2022-1-20 15:01'.to_time
      expect(@reserve_frame.verifyFrameSaturday(test_time1)).to eq false
      expect(@reserve_frame.verifyFrameSaturday(test_time2)).to eq true
      expect(@reserve_frame.verifyFrameSaturday(test_time3)).to eq true
      expect(@reserve_frame.verifyFrameSaturday(test_time4)).to eq true
      expect(@reserve_frame.verifyFrameSaturday(test_time5)).to eq false
    end
    it "verifyFrameHoliday" do
      # 日祝の予約枠の範囲外
      test_time1 = '2022-1-20 00:00'.to_time
      test_time2 = '2022-1-20 00:01'.to_time
      test_time3 = '2022-1-20 12:00'.to_time
      test_time4 = '2022-1-20 23:59'.to_time
      expect(@reserve_frame.verifyFrameHoliday(test_time1)).to eq false
      expect(@reserve_frame.verifyFrameHoliday(test_time2)).to eq false
      expect(@reserve_frame.verifyFrameHoliday(test_time3)).to eq false
      expect(@reserve_frame.verifyFrameHoliday(test_time4)).to eq false
    end
  end
end
