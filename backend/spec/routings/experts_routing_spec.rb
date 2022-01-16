require 'rails_helper'

RSpec.describe "ルーティングテスト Experts", type: :request do
  describe '' do
    context '予約可能枠登録画面 未ログイン' do
      it '一覧表示 404であること' do
        get experts_reservable_frame_register_path
        expect(response).to have_http_status(404)
      end
      it '削除処理 404であること' do
        post experts_reservable_frame_register_path
        expect(response).to have_http_status(404)
      end
    end
    context '予約一覧画面 未ログイン' do
      it '一覧表示 404であること' do
        get("/experts/reserves")
        expect(response).to have_http_status(404)
      end
    end
  end
end
