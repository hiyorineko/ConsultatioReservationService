require 'rails_helper'

RSpec.describe Experts::ReservableFrameRegisterService do
  describe "正常系" do
    before do
      @reservable_frame = FactoryBot.create(:reservable_frame, start_at: '2022-1-31 12:00'.to_time)
      @service = Experts::ReservableFrameRegisterService.new(
        1,
        @reservable_frame.expert_id
      )
      @reserve = FactoryBot.create(:reserve, start_at: '2022-1-20 10:00'.to_time, expert_id: @reservable_frame.expert_id)
      @reservableFrame1 = FactoryBot.create(:reservable_frame, start_at: '2022-2-02 10:00'.to_time, expert_id: @reservable_frame.expert_id)
      @reservableFrame2 = FactoryBot.create(:reservable_frame, start_at: '2022-2-02 17:30'.to_time, expert_id: @reservable_frame.expert_id)
      @reservableFrame3 = FactoryBot.create(:reservable_frame, start_at: '2022-3-01 12:00'.to_time, expert_id: @reservable_frame.expert_id)
      @reservableFrame4 = FactoryBot.create(:reservable_frame, start_at: '2022-3-02 13:30'.to_time, expert_id: @reservable_frame.expert_id)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-08 10:30'.to_time, expert_id: @reservable_frame.expert_id)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-08 11:00'.to_time, expert_id: @reservable_frame.expert_id)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-08 15:00'.to_time, expert_id: @reservable_frame.expert_id)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-08 15:30'.to_time, expert_id: @reservable_frame.expert_id)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-09 12:00'.to_time, expert_id: @reservable_frame.expert_id)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-10 12:00'.to_time, expert_id: @reservable_frame.expert_id)
    end
    around do |e|
      # 日付を固定
      travel_to('2022-1-20 12:00'.to_time) {e.run}
    end
    it "getReservableFrames 平日" do
      result = @service.getReservableFrames
      expect_true = {"datetime" => '2022-1-31 12:00'.to_time, "registered" => true, "reservable" => true, "reserved" => false}
      expect_first = {"datetime" => '2022-1-20 10:00'.to_time, "registered" => false, "reservable" => true, "reserved" => true}
      expect_last = {"datetime" => '2022-2-02 17:30'.to_time, "registered" => true, "reservable" => true, "reserved" => false}
      expect(result).to include "2022-01-20"
      expect(result).to include "2022-02-02"
      expect(result["2022-01-20"].first).to eq expect_first
      expect(result["2022-02-02"].last).to eq expect_last
      expect(result["2022-01-31"]).to include expect_true
    end
    it "getReservableFrames 土日祝" do
      # 日付を固定
      travel_to('2022-1-05 12:00'.to_time)
      result = @service.getReservableFrames
      # 土曜日の予約枠の範囲外
      expect1 = {"datetime" => '2022-1-08 10:30'.to_time, "registered" => true, "reservable" => false, "reserved" => false}
      # 土曜日の予約枠の範囲内
      expect2 = {"datetime" => '2022-1-08 11:00'.to_time, "registered" => true, "reservable" => true, "reserved" => false}
      expect3 = {"datetime" => '2022-1-08 15:00'.to_time, "registered" => true, "reservable" => true, "reserved" => false}
      # 土曜日の予約枠の範囲外
      expect4 = {"datetime" => '2022-1-08 15:30'.to_time, "registered" => true, "reservable" => false, "reserved" => false}
      # 日曜日の予約枠の範囲外
      expect5 = {"datetime" => '2022-1-09 12:00'.to_time, "registered" => true, "reservable" => false, "reserved" => false}
      # 祝日の予約枠の範囲外
      expect6 = {"datetime" => '2022-1-10 12:00'.to_time, "registered" => true, "reservable" => false, "reserved" => false}
      expect(result["2022-01-08"]).to include expect1
      expect(result["2022-01-08"]).to include expect2
      expect(result["2022-01-08"]).to include expect3
      expect(result["2022-01-08"]).to include expect4
      expect(result["2022-01-09"]).to include expect5
      expect(result["2022-01-10"]).to include expect6
    end
    it "verifyReservableFrames" do
      # 平日 予約可能枠の範囲内 予約済みのデータあり
      testcase1 = {"2022-01-20 10:00:00 +0000"=>"0", "2022-01-20 10:30:00 +0000"=>"0", "2022-01-20 11:00:00 +0000"=>"0", "2022-01-20 11:30:00 +0000"=>"0", "2022-01-20 12:00:00 +0000"=>"0", "2022-01-20 12:30:00 +0000"=>"0", "2022-01-20 13:00:00 +0000"=>"0", "2022-01-20 13:30:00 +0000"=>"0", "2022-01-20 14:00:00 +0000"=>"0", "2022-01-20 14:30:00 +0000"=>"0", "2022-01-20 15:00:00 +0000"=>"0", "2022-01-20 15:30:00 +0000"=>"0", "2022-01-20 16:00:00 +0000"=>"0", "2022-01-20 16:30:00 +0000"=>"0", "2022-01-20 17:00:00 +0000"=>"0", "2022-01-20 17:30:00 +0000"=>"0"}
      result1 = @service.verifyReservableFrames(testcase1)
      expect(result1).to eq false
      testcase2 = {"2022-02-01 10:00:00 +0000"=>"0", "2022-02-01 10:30:00 +0000"=>"0", "2022-02-01 11:00:00 +0000"=>"0", "2022-02-01 11:30:00 +0000"=>"0", "2022-02-01 12:00:00 +0000"=>"0", "2022-02-01 12:30:00 +0000"=>"0", "2022-02-01 13:00:00 +0000"=>"0", "2022-02-01 13:30:00 +0000"=>"0", "2022-02-01 14:00:00 +0000"=>"0", "2022-02-01 14:30:00 +0000"=>"0", "2022-02-01 15:00:00 +0000"=>"0", "2022-02-01 15:30:00 +0000"=>"0", "2022-02-01 16:00:00 +0000"=>"0", "2022-02-01 16:30:00 +0000"=>"0", "2022-02-01 17:00:00 +0000"=>"0", "2022-02-01 17:30:00 +0000"=>"0"}
      # 平日 予約可能枠の範囲内 予約済みのデータなし
      result2 = @service.verifyReservableFrames(testcase2)
      expect(result2).to eq true
      # 平日 予約可能枠の範囲外 予約済みのデータなし
      testcase3 = {"2022-02-01 09:30:00 +0000"=>"0", "2022-02-01 10:00:00 +0000"=>"0"}
      result3 = @service.verifyReservableFrames(testcase3)
      expect(result3).to eq false
      # 土曜日  予約可能枠の範囲外
      testcase4 = {"2022-01-08 10:30:00 +0000"=>"0"}
      result4 = @service.verifyReservableFrames(testcase4)
      expect(result4).to eq false
      # 土曜日  予約可能枠の範囲内
      testcase5 = {"2022-01-08 11:00:00 +0000"=>"0"}
      result5 = @service.verifyReservableFrames(testcase5)
      expect(result5).to eq true
      # 土曜日  予約可能枠の範囲内
      testcase6 = {"2022-01-08 15:00:00 +0000"=>"0"}
      result6 = @service.verifyReservableFrames(testcase6)
      expect(result6).to eq true
      # 土曜日  予約可能枠の範囲外
      testcase7 = {"2022-01-08 15:30:00 +0000"=>"0"}
      result7 = @service.verifyReservableFrames(testcase7)
      expect(result7).to eq false
      # 日曜日  予約可能枠の範囲外
      testcase8 = {"2022-01-09 12:00:00 +0000"=>"0"}
      result8 = @service.verifyReservableFrames(testcase8)
      expect(result8).to eq false
      # 祝日  予約可能枠の範囲外
      testcase9 = {"2022-01-10 12:00:00 +0000"=>"0"}
      result9 = @service.verifyReservableFrames(testcase9)
      expect(result9).to eq false
    end
    it "reservableFramesRegister" do
      testcase = {"2022-02-02 10:00:00 +0000"=>"0", "2022-02-02 10:30:00 +0000"=>"0", "2022-02-02 11:00:00 +0000"=>"1", "2022-02-02 11:30:00 +0000"=>"0", "2022-02-02 12:00:00 +0000"=>"0", "2022-02-02 12:30:00 +0000"=>"0", "2022-02-02 13:00:00 +0000"=>"0", "2022-02-02 13:30:00 +0000"=>"0", "2022-02-02 14:00:00 +0000"=>"0", "2022-02-02 14:30:00 +0000"=>"0", "2022-02-02 15:00:00 +0000"=>"0", "2022-02-02 15:30:00 +0000"=>"0", "2022-02-02 16:00:00 +0000"=>"0", "2022-02-02 16:30:00 +0000"=>"0", "2022-02-02 17:00:00 +0000"=>"0", "2022-02-02 17:30:00 +0000"=>"0"}
      expect{ @service.reservableFramesRegister(testcase) }.to change(ReservableFrame,:count).by(-2)
      expect(ReservableFrame.where(id: @reservableFrame1.id )).not_to exist
      expect(ReservableFrame.where(id: @reservableFrame2.id )).not_to exist
      expect(ReservableFrame.where(id: @reservableFrame3.id )).to exist
      expect(ReservableFrame.where(id: @reservableFrame4.id )).to exist
      expect(ReservableFrame.where(expert_id: @reservable_frame.expert_id, start_at: "2022-02-02 11:00:00 +0000")).to exist
    end
  end
end
