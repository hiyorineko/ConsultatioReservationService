class Experts::ReservableFrameRegisterController < ApplicationController
  layout 'experts'
  protect_from_forgery
  def service_init
    @service = Experts::ReservableFrameRegisterService.new(
      params[:page],
      current_expert.id
    )
  end

  def index
    service_init
    @page = @service.getParamPage
    @dates = @service.getDates
    @frames = @service.getReserveFrames
    @reservable_frames = @service.getReservableFrames
  end

  def register
    service_init
    unless @service.verifyReservableFrames(params[:reservable_frames])
      redirect_to experts_reservable_frame_register_path, notice: '予約登録されている予約枠を削除することはできません。'
    end
    @service.reservableFramesRegister(params[:reservable_frames])
    redirect_to experts_reservable_frame_register_path(page: @service.getParamPage),
                notice: '予約可能枠を登録しました。'
  end
end
