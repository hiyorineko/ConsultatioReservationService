require 'rails_helper'

RSpec.describe Experts::ProfileController, type: :controller do
  describe "プロフィール登録画面" do
    before do
      @expert_type1 = FactoryBot.create(:expert_type)
      @expert_type2 = FactoryBot.create(:expert_type)
      @expert = FactoryBot.create(:expert, expert_type_id: @expert_type1.id)
      login_expert(@expert)
    end
    it "プロフィール登録画面 テンプレートが表示されること" do
      get :edit
      expect(assigns(:expert)).to eq @expert
      expect(response).to render_template :edit
    end
    it "プロフィール登録処理 プロフィールが編集されていること テンプレートが表示されること" do
      patch :update, params: {
        name: "テストネーム",
        profile: "テストプロフィール",
        user_image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.png')),
        expert_type_id: @expert_type2.id
      }
      expert = Expert.find(@expert.id)
      expect(expert.name).to eq "テストネーム"
      expect(expert.profile).to eq "テストプロフィール"
      expect(expert.user_image.to_s).to eq "/uploads/expert/user_image/1/test.png"
      expect(expert.expert_type_id).to eq @expert_type2.id
      expect(response).to redirect_to("/experts/profile")
    end
  end
end
