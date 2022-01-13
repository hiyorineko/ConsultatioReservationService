require 'rails_helper'

RSpec.describe Users::ReservesController, type: :controller do
  describe "#index" do
    context "as a authenticated user" do
      before do
        @reserve1 = FactoryBot.create(:reserve)
        @reserve2 = FactoryBot.create(:reserve)
        @reserve1.user.confirm
        sign_in(@reserve1.user)
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
      it "予約削除処理 予約が削除されず、一覧画面にリダイレクトされること" do
        expect{
          delete :delete, params: { reserve_id: @reserve2.id }
        }.to change(Reserve,:count).by(0)
        expect(Reserve.where(id: @reserve2.id )).to exist
        expect(response).to redirect_to("/users/reserves")
      end
    end
  end
end
