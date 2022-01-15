require 'rails_helper'

RSpec.describe Users::ReserveRegisterController, type: :controller do
  describe "予約登録画面" do
    before do
      @reservable_frame = FactoryBot.create(:reservable_frame, start_at: '2022-1-31 12:00'.to_time)
      FactoryBot::create(:expert)
      @user = FactoryBot.create(:user)
      @user.confirm
      sign_in(@user)
    end
    around do |e|
      # 日付を固定
      travel_to('2022-1-20 12:00'.to_time) {e.run}
    end
    it "予約枠一覧画面表示 予約枠が取得できていること テンプレートが表示されること" do
      get :index, params: { page: 1, expert_id: @reservable_frame.expert_id }
      expect(assigns(:page)).to eq 1
      expect(assigns(:expert_id)).to eq @reservable_frame.expert_id
      expect(assigns(:expert)).to eq @reservable_frame.expert
      expect(assigns(:experts)).to include @reservable_frame.expert
      expect_date = {"date" => Date.new(2022, 2, 2), "day" =>"(水)"}
      expect(assigns(:dates)).to include "2022年02月"
      expect(assigns(:dates)["2022年02月"]).to include expect_date
      expect_reservable_frame = {"datetime" => '2022-1-20 10:00'.to_time, "reservable" => false}
      expect(assigns(:reservable_frames)).to include "2022-01-20"
      expect(assigns(:reservable_frames)["2022-01-20"]).to include expect_reservable_frame
      expect(response).to render_template :index
    end
    it "予約登録確認画面処理 登録内容が渡されていること テンプレートが表示されること" do
      get :confirm, params: { expert_id: @reservable_frame.expert_id, datetime: @reservable_frame.start_at }
      expect(assigns(:datetime).to_time).to eq @reservable_frame.start_at
      expect(assigns(:expert_id)).to eq @reservable_frame.expert_id
      expect(assigns(:expert)).to eq @reservable_frame.expert
      expect(response).to render_template :confirm
    end
    it "予約登録処理 予約が登録され、予約一覧画面にリダイレクトされること" do
      post :register, params: { expert_id: @reservable_frame.expert_id,
                                datetime: @reservable_frame.start_at,
      }
      expect(response).to redirect_to("/users/reserves")
    end
    it "予約登録処理 対象の予約可能枠が存在しない場合 404となること" do
      post :register, params: { datetime: '1099-1-31 12:00'.to_time }
      expect(response).to have_http_status(404)
    end
  end
end
