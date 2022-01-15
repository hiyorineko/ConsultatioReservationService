require 'rails_helper'

RSpec.describe Users::ReserveRegisterService do
  describe "正常系" do
    before do
      @reservable_frame = FactoryBot.create(:reservable_frame, start_at: '2022-1-31 12:00'.to_time)
      @user = FactoryBot.create(:user)
      FactoryBot::create(:expert)
      @reserve_register_service = Users::ReserveRegisterService.new(
        1,
        @reservable_frame.expert_id,
        @reservable_frame.start_at,
        "test comment"
      )
    end
    around do |e|
      # 日付を固定
      travel_to('2022-1-20 12:00'.to_time) {e.run}
    end
    it "getDates" do
      expect_first = {"date" => Date.new(2022, 1, 20), "day" =>"(木)"}
      expect_count = 14
      expect_last = {"date" => Date.new(2022, 2, 2), "day" =>"(水)"}
      result = @reserve_register_service.getDates
      expect(result).to include "2022年01月"
      expect(result).to include "2022年02月"
      expect(result["2022年01月"].count + result["2022年02月"].count).to eq expect_count
      expect(result["2022年01月"].first).to eq expect_first
      expect(result["2022年02月"].last).to eq expect_last
    end
    it "getReservableFrames" do
      result = @reserve_register_service.getReservableFrames
      expect_true = {"datetime" => '2022-1-31 12:00'.to_time, "reservable" => true}
      expect_first = {"datetime" => '2022-1-20 10:00'.to_time, "reservable" => false}
      expect_last = {"datetime" => '2022-2-02 18:00'.to_time, "reservable" => false}
      expect(result).to include "2022-01-20"
      expect(result).to include "2022-02-02"
      expect(result["2022-01-20"].first).to eq expect_first
      expect(result["2022-02-02"].last).to eq expect_last
      expect(result["2022-01-31"]).to include expect_true
    end
    it "getStartDate" do
      result = @reserve_register_service.getStartDate
      expect(result).to eq Date.new(2022, 1, 20)
    end
    it "getLastDate" do
      result = @reserve_register_service.getLastDate
      expect(result).to eq Date.new(2022, 2, 2)
    end
    it "getStartFrame" do
      result = @reserve_register_service.getStartFrame
      expect(result).to eq '2022-1-20 10:00'.to_time
    end
    it "getLastFrame" do
      result = @reserve_register_service.getLastFrame
      expect(result).to eq '2022-2-02 18:00'.to_time
    end
    it "getReserveFrames" do
      result = @reserve_register_service.getReserveFrames
      expect(result.first).to eq '2022-1-20 10:00'.to_time
      expect(result.last).to eq '2022-1-20 18:00'.to_time
    end
    it "getParamPage" do
      result = @reserve_register_service.getParamPage
      expect(result).to eq 1
    end
    it "getParamExpertId" do
      result = @reserve_register_service.getParamExpertId
      expect(result).to eq @reservable_frame.expert_id
    end
    it "getExpert" do
      result = @reserve_register_service.getExpert
      expect(result).to eq @reservable_frame.expert
    end
    it "getAllExperts" do
      result = @reserve_register_service.getAllExperts
      expect(result).to include @reservable_frame.expert
      expect(result.count).to eq 2
    end
    it "reserveRegister" do
      @reserve_register_service.reserveRegister(@user.id)
      expect(ReservableFrame.where(id: @reservable_frame.id )).not_to exist
      expect(Reserve.where(user_id: @user.id, expert_id: @reservable_frame.expert_id, start_at: @reservable_frame.start_at )).to exist
    end
    it "getParamDateTime" do
      result = @reserve_register_service.getParamDateTime
      expect(result.to_i).to eq @reservable_frame.start_at.to_i
    end
  end
end
