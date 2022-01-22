class Users::ReservesController < ApplicationController
  layout 'users'
  def index
    @reserves = Reserve.eager_load({expert: :expert_type})
                       .where(user_id: current_user.id)
                       .order(start_at: "DESC")
  end

  def delete
    reserve = Reserve.find_by(id: params[:reserve_id], user_id: current_user.id)
    if reserve.nil?
      redirect_to "/users/reserves", notice: '予約の取り消しに失敗しました。'
      return
    end
    reserve.destroy
    redirect_to "/users/reserves", notice: '予約の取り消しが完了しました。'
  end
end
