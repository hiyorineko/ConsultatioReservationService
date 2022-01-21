class Experts::ReservesController < ApplicationController
  layout 'experts'
  def index
    @reserves = Reserve.eager_load(:user)
                       .where(expert_id: current_expert.id)
                       .order(start_at: "DESC")
  end
end
