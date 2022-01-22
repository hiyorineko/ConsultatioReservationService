require 'rails_helper'

RSpec.describe Users::ReserveRegisterService do
  describe "正常系" do
    before do
      @reservable_frame = FactoryBot.create(:reservable_frame, start_at: '2022-1-31 12:00'.to_time)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-08 10:30'.to_time, expert_id: @reservable_frame.expert_id)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-08 11:00'.to_time, expert_id: @reservable_frame.expert_id)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-08 15:00'.to_time, expert_id: @reservable_frame.expert_id)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-08 15:30'.to_time, expert_id: @reservable_frame.expert_id)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-09 12:00'.to_time, expert_id: @reservable_frame.expert_id)
      FactoryBot.create(:reservable_frame, start_at: '2022-1-10 12:00'.to_time, expert_id: @reservable_frame.expert_id)
      @reservable_frame_other_expert_type = FactoryBot.create(:reservable_frame, start_at: '2022-1-22 12:00'.to_time)
      @user = FactoryBot.create(:user)
      FactoryBot::create(:expert)
      @reserve_register_service = Users::ReserveRegisterService.new(
        1,
        @reservable_frame.expert_id,
        @reservable_frame.start_at,
        "test comment",
        @reservable_frame.expert.expert_type_id
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
    it "getReservableFrames 平日" do
      result = @reserve_register_service.getReservableFrames
      expect_true = {"datetime" => '2022-1-31 12:00'.to_time, "reservable" => true}
      expect_first = {"datetime" => '2022-1-20 10:00'.to_time, "reservable" => false}
      expect_last = {"datetime" => '2022-2-02 18:00'.to_time, "reservable" => false}
      expect_not_include = {"datetime" => '2022-1-22 12:00'.to_time, "reservable" => true}
      expect(result).to include "2022-01-20"
      expect(result).to include "2022-02-02"
      expect(result["2022-01-20"].first).to eq expect_first
      expect(result["2022-02-02"].last).to eq expect_last
      expect(result["2022-01-31"]).to include expect_true
      expect(result["2022-01-22"]).not_to include expect_not_include
    end
    it "getReservableFrames 土日祝" do
      # 日付を固定
      travel_to('2022-1-05 12:00'.to_time)
      result = @reserve_register_service.getReservableFrames
      # 土曜日の予約枠の範囲外
      expect1 = {"datetime" => '2022-1-08 10:30'.to_time, "reservable" => false}
      # 土曜日の予約枠の範囲内
      expect2 = {"datetime" => '2022-1-08 11:00'.to_time, "reservable" => true}
      expect3 = {"datetime" => '2022-1-08 15:00'.to_time, "reservable" => true}
      # 土曜日の予約枠の範囲外
      expect4 = {"datetime" => '2022-1-08 15:30'.to_time, "reservable" => false}
      # 日曜日の予約枠の範囲外
      expect5 = {"datetime" => '2022-1-09 12:00'.to_time, "reservable" => false}
      # 祝日の予約枠の範囲外
      expect6 = {"datetime" => '2022-1-10 12:00'.to_time, "reservable" => false}
      expect(result["2022-01-08"]).to include expect1
      expect(result["2022-01-08"]).to include expect2
      expect(result["2022-01-08"]).to include expect3
      expect(result["2022-01-08"]).to include expect4
      expect(result["2022-01-09"]).to include expect5
      expect(result["2022-01-10"]).to include expect6
    end
    it "getReservableFrames expert_typeが異なる枠が予約可能枠として表示されていないこと" do
      result = @reserve_register_service.getReservableFrames
      expect_not_include = {"datetime" => @reservable_frame_other_expert_type.start_at, "reservable" => true}
      expect(result["2022-01-22"]).not_to include expect_not_include
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
    it "getExperts" do
      result = @reserve_register_service.getExperts
      expect(result).to include @reservable_frame.expert
      expect(result.count).to eq 1
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
    it "getAllExpertTypes" do
      result = @reserve_register_service.getAllExpertTypes
      expect(result).to include @reservable_frame.expert.expert_type
      expect(result).to include @reservable_frame_other_expert_type.expert.expert_type
    end
    it "getParamExpertTypeId" do
      result = @reserve_register_service.getParamExpertTypeId
      expect(result).to eq @reservable_frame.expert.expert_type_id
    end
    it "getExpertType" do
      result = @reserve_register_service.getExpertType
      expect(result).to eq @reservable_frame.expert.expert_type
    end
  end
end
