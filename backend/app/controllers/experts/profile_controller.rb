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
      user_image: params[:user_image]
    )
    redirect_to experts_profile_path,
                notice: 'プロフィールを更新しました。'
  end
end
