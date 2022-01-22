class Users::ReservesController < ApplicationController
  layout 'users'
  def index
    @reserves = Reserve.eager_load({expert: :expert_type})
                       .where(user_id: current_user.id)
                       .order(start_at: "DESC")
  end

  def delete
    reserve = Reserve.find_by(id: params[:reserve_id], user_id: current_user.id)
    if reserve.nil? || reserve.start_at.to_i <= Time.now.to_i
      redirect_to "/users/reserves", notice: '予約のキャンセルに失敗しました。'
      return
    end

    user = User.find(reserve.user_id)
    expert = Expert.find(reserve.expert_id)
    expert_type = ExpertType.find(expert.expert_type_id)

    ## 予約キャンセルの通知
    ReserveRegisterMailer.send_reserve_cancel_email_to_user(reserve, user, expert, expert_type).deliver
    ReserveRegisterMailer.send_reserve_cancel_email_to_expert(reserve, user, expert_type).deliver

    reserve.destroy
    redirect_to "/users/reserves", notice: '予約をキャンセルしました。'
  end
end
