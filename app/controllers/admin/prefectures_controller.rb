class Admin::PrefecturesController < ApplicationController
  before_action :authenticate_administrator!
  before_action :get_prefecture,only: [:edit, :update, :confirm_delete, :destroy]
  def confirm_delete
  end
  def index
    @prefectures = Prefecture.all
  end
  def new
    @prefecture = Prefecture.new
  end
  def create
    @prefecture=Prefecture.new(update_params_prefecture)
    if @prefecture.save
      flash[:notice] = "地区が追加されました"
      redirect_to admin_prefectures_path
    else
      flash[:notice] = "地区が追加できませんでした"
     render :new_prefecture
    end
  end
  def edit
  end
  def update
    if @prefecture.update(update_params_prefecture)
      flash[:notice] = "県が変更されました"
      redirect_to admin_prefectures_path
    end
  end
  def destroy
    if @prefecture.destroy
      flash[:notice] = "県が削除されました"
    else
      flash[:notice] = "県が削除されませんでした"
    end
    redirect_to admin_prefectures_path
  end
private
  def get_prefecture
    @prefecture = Prefecture.find(params[:id])
  end
  def update_params_prefecture
    params.require(:prefecture).permit(:prefecture)
  end

end
