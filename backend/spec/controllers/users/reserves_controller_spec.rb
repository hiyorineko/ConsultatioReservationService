require 'rails_helper'

RSpec.describe Users::ReservesController, type: :controller do
  describe "予約一覧画面" do
    before do
      @reserve1 = FactoryBot.create(:reserve, start_at: '2022-1-21 12:00'.to_time)
      @reserve2 = FactoryBot.create(:reserve, start_at: '2022-1-23 12:00'.to_time)
      @reserve3 = FactoryBot.create(:reserve, start_at: '2022-1-20 11:59'.to_time, user_id: @reserve1.user_id)
      @reserve4 = FactoryBot.create(:reserve, start_at: '2022-1-20 12:00'.to_time, user_id: @reserve1.user_id)
      @reserve1.user.confirm
      sign_in(@reserve1.user)
    end
    around do |e|
      # 日付を固定
      travel_to('2022-1-20 12:00'.to_time) {e.run}
    end
    it "予約一覧画面 予約が取得できていること テンプレートが表示されること" do
      get :index
      expect(assigns(:reserves)).to include @reserve1
      expect(assigns(:reserves)).not_to include @reserve2
      expect(response).to render_template :index
    end
    it "予約削除処理 予約が1件削除され、一覧画面にリダイレクトされること" do
      expect{
        delete :delete, params: { reserve_id: @reserve1.id }
      }.to change(Reserve,:count).by(-1)
      expect(Reserve.where(id: @reserve1.id )).not_to exist
      expect(response).to redirect_to("/users/reserves")
    end
    it "予約削除処理 異なるユーザーの予約の場合、削除されず、一覧画面にリダイレクトされること" do
      expect{
        delete :delete, params: { reserve_id: @reserve2.id }
      }.to change(Reserve,:count).by(0)
      expect(Reserve.where(id: @reserve2.id )).to exist
      expect(response).to redirect_to("/users/reserves")
    end
    it "予約削除処理 開始時刻をすぎた予約の場合、削除されず、一覧画面にリダイレクトされること" do
      expect{
        delete :delete, params: { reserve_id: @reserve3.id }
      }.to change(Reserve,:count).by(0)
      expect(Reserve.where(id: @reserve3.id )).to exist
      expect(response).to redirect_to("/users/reserves")
    end
    it "予約削除処理 開始時刻が現在時刻と同じ予約の場合、削除されず、一覧画面にリダイレクトされること" do
      expect{
        delete :delete, params: { reserve_id: @reserve4.id }
      }.to change(Reserve,:count).by(0)
      expect(Reserve.where(id: @reserve4.id )).to exist
      expect(response).to redirect_to("/users/reserves")
    end
  end
end
