require 'rails_helper'

RSpec.describe Users::MypageController, type: :controller do
  describe "マイページ画面" do
    before do
      @user = FactoryBot.create(:user)
      login(@user)
    end
    it "プロフィール登録画面 テンプレートが表示されること" do
      get :index
      expect(response).to render_template :index
    end
  end
end
