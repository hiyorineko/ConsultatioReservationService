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
      @reservableFrame2 = FactoryBot.create(:reservable_frame, start_at: '2022-2-02 18:00'.to_time, expert_id: @reservable_frame.expert_id)
      @reservableFrame3 = FactoryBot.create(:reservable_frame, start_at: '2022-3-01 12:00'.to_time, expert_id: @reservable_frame.expert_id)
      @reservableFrame4 = FactoryBot.create(:reservable_frame, start_at: '2022-3-02 13:30'.to_time, expert_id: @reservable_frame.expert_id)
    end
    around do |e|
      # 日付を固定
      travel_to('2022-1-20 12:00'.to_time) {e.run}
    end
    it "getReservableFrames" do
      result = @service.getReservableFrames
      expect_true = {"datetime" => '2022-1-31 12:00'.to_time, "registered" => true, "reserved" => false}
      expect_first = {"datetime" => '2022-1-20 10:00'.to_time, "registered" => false, "reserved" => true}
      expect_last = {"datetime" => '2022-2-02 18:00'.to_time, "registered" => true, "reserved" => false}
      expect(result).to include "2022-01-20"
      expect(result).to include "2022-02-02"
      expect(result["2022-01-20"].first).to eq expect_first
      expect(result["2022-02-02"].last).to eq expect_last
      expect(result["2022-01-31"]).to include expect_true
    end
    it "verifyReservableFrames" do
      testcase1 = [{"2022-01-20 10:00:00 +0000"=>"0", "2022-01-20 10:30:00 +0000"=>"0", "2022-01-20 11:00:00 +0000"=>"0", "2022-01-20 11:30:00 +0000"=>"0", "2022-01-20 12:00:00 +0000"=>"0", "2022-01-20 12:30:00 +0000"=>"0", "2022-01-20 13:00:00 +0000"=>"0", "2022-01-20 13:30:00 +0000"=>"0", "2022-01-20 14:00:00 +0000"=>"0", "2022-01-20 14:30:00 +0000"=>"0", "2022-01-20 15:00:00 +0000"=>"0", "2022-01-20 15:30:00 +0000"=>"0", "2022-01-20 16:00:00 +0000"=>"0", "2022-01-20 16:30:00 +0000"=>"0", "2022-01-20 17:00:00 +0000"=>"0", "2022-01-20 17:30:00 +0000"=>"0", "2022-01-20 18:00:00 +0000"=>"0"}]
      result = @service.verifyReservableFrames(testcase1)
      expect(result).to eq false
      testcase2 = [{"2022-02-01 10:00:00 +0000"=>"0", "2022-02-01 10:30:00 +0000"=>"0", "2022-02-01 11:00:00 +0000"=>"0", "2022-02-01 11:30:00 +0000"=>"0", "2022-02-01 12:00:00 +0000"=>"0", "2022-02-01 12:30:00 +0000"=>"0", "2022-02-01 13:00:00 +0000"=>"0", "2022-02-01 13:30:00 +0000"=>"0", "2022-02-01 14:00:00 +0000"=>"0", "2022-02-01 14:30:00 +0000"=>"0", "2022-02-01 15:00:00 +0000"=>"0", "2022-02-01 15:30:00 +0000"=>"0", "2022-02-01 16:00:00 +0000"=>"0", "2022-02-01 16:30:00 +0000"=>"0", "2022-02-01 17:00:00 +0000"=>"0", "2022-02-01 17:30:00 +0000"=>"0", "2022-02-01 18:00:00 +0000"=>"0"}]
      result = @service.verifyReservableFrames(testcase2)
      expect(result).to eq true
    end
    it "reservableFramesRegister" do
      testcase = [{"2022-02-02 10:00:00 +0000"=>"0", "2022-02-02 10:30:00 +0000"=>"0", "2022-02-02 11:00:00 +0000"=>"1", "2022-02-02 11:30:00 +0000"=>"0", "2022-02-02 12:00:00 +0000"=>"0", "2022-02-02 12:30:00 +0000"=>"0", "2022-02-02 13:00:00 +0000"=>"0", "2022-02-02 13:30:00 +0000"=>"0", "2022-02-02 14:00:00 +0000"=>"0", "2022-02-02 14:30:00 +0000"=>"0", "2022-02-02 15:00:00 +0000"=>"0", "2022-02-02 15:30:00 +0000"=>"0", "2022-02-02 16:00:00 +0000"=>"0", "2022-02-02 16:30:00 +0000"=>"0", "2022-02-02 17:00:00 +0000"=>"0", "2022-02-02 17:30:00 +0000"=>"0", "2022-02-02 18:00:00 +0000"=>"0"}]
      expect{ @service.reservableFramesRegister(testcase) }.to change(ReservableFrame,:count).by(-2)
      expect(ReservableFrame.where(id: @reservableFrame1.id )).not_to exist
      expect(ReservableFrame.where(id: @reservableFrame2.id )).not_to exist
      expect(ReservableFrame.where(id: @reservableFrame3.id )).to exist
      expect(ReservableFrame.where(id: @reservableFrame4.id )).to exist
      expect(ReservableFrame.where(expert_id: @reservable_frame.expert_id, start_at: "2022-02-02 11:00:00 +0000")).to exist
    end
  end
end
