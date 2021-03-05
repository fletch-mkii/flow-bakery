class CookiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @oven = current_user.ovens.find_by!(id: params[:oven_id])
    if @oven.in_use?
      redirect_to @oven, alert: 'A batch of cookies is already in the oven!'
    else
      @cookie = Cookie.new(storage_id: @oven.id, storage_type: 'Oven')
    end
  end

  def create
    @oven = current_user.ovens.find_by!(id: params[:oven_id])
    CookieBatchBaker.perform(cookie_params[:fillings], cookie_params[:cookie_batch_size].to_i, @oven)
    redirect_to oven_path(@oven)
  end

  private

  def cookie_params
    params.require(:cookie).permit(:fillings, :cookie_batch_size)
  end
end
