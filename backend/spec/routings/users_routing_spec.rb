require 'rails_helper'

RSpec.describe "ルーティングテスト Users", type: :request do
  describe '' do
    context '予約一覧画面 ログイン済' do
      before do
        @reserve = FactoryBot.create(:reserve)
        @reserve.user.confirm
        sign_in(@reserve.user)
      end
      it '一覧表示 200であること' do
        get("/users/reserves")
        expect(response).to have_http_status(200)
      end
      it '削除処理 200であること' do
        delete "/users/reserve/delete/#{@reserve.id}"
        expect(response).to have_http_status(302)
      end
    end
    context '予約一覧画面 未ログイン' do
      it '一覧表示 404であること' do
        get("/users/reserves")
        expect(response).to have_http_status(404)
      end
      it '削除処理 404であること' do
        delete "/users/reserve/delete/1"
        expect(response).to have_http_status(404)
      end
    end
  end
end
