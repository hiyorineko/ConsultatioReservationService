class Experts::ProfileController < ApplicationController
  layout 'experts'
  def edit
    @expert = current_expert
  end

  def update
    Expert.update(
      current_expert.id,
      name: params[:name],
      profile: params[:profile],
      expert_type_id: params[:expert_type_id]
    )

    ## 画像更新処理
    if params[:user_image]
      Expert.find(current_expert.id).remove_user_image!
      Expert.update(
        current_expert.id,
        user_image: params[:user_image]
      )
    end

    redirect_to experts_profile_path,
                notice: 'プロフィールを更新しました。'
  end
end
