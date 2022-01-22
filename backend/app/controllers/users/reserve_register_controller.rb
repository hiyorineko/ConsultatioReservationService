class Users::ReserveRegisterController < ApplicationController
  layout 'users'
  protect_from_forgery
  def service_init
    @reserve_register_service = Users::ReserveRegisterService.new(
      params[:page],
      params[:expert_id],
      params[:datetime],
      params[:user_comment],
      params[:expert_type_id] ? params[:expert_type_id] : 1
      )
  end

  def index
    service_init
    @page = @reserve_register_service.getParamPage
    @expert_id = @reserve_register_service.getParamExpertId
    @expert = @reserve_register_service.getExpert
    @experts = @reserve_register_service.getExperts
    @expert_types = @reserve_register_service.getAllExpertTypes
    @expert_type_id = @reserve_register_service.getParamExpertTypeId
    @dates = @reserve_register_service.getDates
    @frames = @reserve_register_service.getReserveFrames
    @reservable_frames = @reserve_register_service.getReservableFrames
  end

  def confirm
    service_init
    @expert_id = @reserve_register_service.getParamExpertId
    @datetime = @reserve_register_service.getParamDateTime
    @expert = @reserve_register_service.getExpert
    @expert_type = @reserve_register_service.getExpertType
  end

  def register
    service_init
    @reserve_register_service.reserveRegister(current_user.id)
    redirect_to "/users/reserves", notice: '予約を登録しました。'
  end
end
