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
      it '削除処理 302であること' do
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
    context '予約登録画面 ログイン済' do
      before do
        @reservable_frame = FactoryBot.create(:reservable_frame)
        @user = FactoryBot.create(:user)
        @user.confirm
        sign_in(@user)
      end
      it '予約枠一覧画面表示 200であること' do
        get("/users/reserve_register")
        expect(response).to have_http_status(200)
      end
      it '予約確認画面表示 200であること' do
        get("/users/reserve_register/confirm?datetime=#{@reservable_frame.start_at}")
        expect(response).to have_http_status(200)
      end
      it '登録処理 302であること' do
        post("/users/reserve_register", params: {expert_id: @reservable_frame.expert_id, datetime: @reservable_frame.start_at})
        expect(response).to have_http_status(302)
      end
    end
    context '予約登録画面 ログイン済未ログイン' do
      it '画面表示 404であること' do
        get("/users/reserve_register")
        expect(response).to have_http_status(404)
      end
      it '登録処理  404であること' do
        get("/users/reserve_register/confirm")
        expect(response).to have_http_status(404)
      end
    end
  end
end
