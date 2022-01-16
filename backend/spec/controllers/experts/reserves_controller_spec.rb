require 'rails_helper'

RSpec.describe Experts::ReservesController, type: :controller do
  describe "予約一覧画面" do
    before do
      @reserve1 = FactoryBot.create(:reserve)
      @reserve2 = FactoryBot.create(:reserve)
      login_expert(@reserve1.expert)
    end
    it "予約一覧画面 予約が取得できていること テンプレートが表示されること" do
      get :index
      expect(assigns(:reserves)).to include @reserve1
      expect(assigns(:reserves)).not_to include @reserve2
      expect(response).to render_template :index
    end
  end
end
