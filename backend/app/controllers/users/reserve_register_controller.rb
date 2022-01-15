class Users::ReserveRegisterController < ApplicationController
  layout 'users'
  protect_from_forgery
  def service_init
    @reserve_register_service = Users::ReserveRegisterService.new(
      params[:page],
      params[:expert_id],
      params[:datetime],
      params[:user_comment]
    )
  end

  def index
    service_init
    @page = @reserve_register_service.getParamPage
    @expert_id = @reserve_register_service.getParamExpertId
    @expert = @reserve_register_service.getExpert
    @experts = @reserve_register_service.getAllExperts
    @dates = @reserve_register_service.getDates
    @frames = @reserve_register_service.getReserveFrames
    @reservable_frames = @reserve_register_service.getReservableFrames
  end

  def confirm
    service_init
    @expert_id = @reserve_register_service.getParamExpertId
    @datetime = @reserve_register_service.getParamDateTime
    @expert = @reserve_register_service.getExpert
  end

  def register
    service_init
    @reserve_register_service.reserveRegister(current_user.id)
    redirect_to "/users/reserves", notice: '予約を登録しました。'
  end
end
