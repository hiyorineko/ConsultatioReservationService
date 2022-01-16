require 'rails_helper'

RSpec.describe Experts::ReservableFrameRegisterController, type: :controller do
  describe "予約登録画面" do
    before do
      @reservable_frame = FactoryBot.create(:reservable_frame, start_at: '2022-1-31 12:00'.to_time)
      login_expert(@reservable_frame.expert)
    end
    around do |e|
      # 日付を固定
      travel_to('2022-1-20 12:00'.to_time) {e.run}
    end
    it "予約可能枠一覧画面表示 予約可能枠が取得できていること テンプレートが表示されること" do
      get :index, params: { page: 1, expert_id: @reservable_frame.expert_id }
      expect(assigns(:page)).to eq 1
      expect_date = {"date" => Date.new(2022, 2, 2), "day" =>"(水)"}
      expect(assigns(:dates)).to include "2022年02月"
      expect(assigns(:dates)["2022年02月"]).to include expect_date
      expect_reservable_frame = {"datetime" => '2022-1-20 10:00'.to_time,
                                 "registered" => false,
                                 "reserved" => false}
      expect(assigns(:reservable_frames)).to include "2022-01-20"
      expect(assigns(:reservable_frames)["2022-01-20"]).to include expect_reservable_frame
      expect(response).to render_template :index
    end
    it "予約可能枠登録処理 登録処理完了後、予約可能枠一覧画面にリダイレクトされること" do
      post :register, params: { page: 1,
                                reservable_frames: [{"2022-02-02 10:00:00 +0000"=>"0", "2022-02-02 10:30:00 +0000"=>"0", "2022-02-02 11:00:00 +0000"=>"1", "2022-02-02 11:30:00 +0000"=>"0", "2022-02-02 12:00:00 +0000"=>"0", "2022-02-02 12:30:00 +0000"=>"0", "2022-02-02 13:00:00 +0000"=>"0", "2022-02-02 13:30:00 +0000"=>"0", "2022-02-02 14:00:00 +0000"=>"0", "2022-02-02 14:30:00 +0000"=>"0", "2022-02-02 15:00:00 +0000"=>"0", "2022-02-02 15:30:00 +0000"=>"0", "2022-02-02 16:00:00 +0000"=>"0", "2022-02-02 16:30:00 +0000"=>"0", "2022-02-02 17:00:00 +0000"=>"0", "2022-02-02 17:30:00 +0000"=>"0", "2022-02-02 18:00:00 +0000"=>"0"}]
      }
      expect(response).to redirect_to("/experts/reservable_frame_register?page=1")
    end
  end
end
