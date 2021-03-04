class OvensController < ApplicationController
  before_action :authenticate_user!

  def index
    @ovens = current_user.ovens
  end

  def show
    @oven = current_user.ovens.find_by!(id: params[:id])
  end

  def empty
    @oven = current_user.ovens.find_by!(id: params[:id])
    if @oven.cookies
      @oven.cookies.update_all(storage_id: current_user.id, storage_type: "User")
    end
    redirect_to @oven, alert: 'Oven emptied!'
  end

  def baking_status
    @oven = current_user.ovens.find_by!(id: params[:id])
    render partial: 'ovens/cookie_info', locals: { oven: @oven }
  end
end
