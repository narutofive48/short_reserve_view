class FavoritesController < ApplicationController
  before_action :get_favorite,only: [ :destroy ]
  def create
    if Favorite.create(uaccount_id: current_uaccount.id, oaccount_id: params[:oaccount_id])
      flash[:notice] = "お気に入りに登録されました"
    else
      flash[:notice] = "お気に入りに登録されませんでした"
    end
    redirect_to info_type_reserves_path
  end
  def destroy
    if @favorite.delete
      flash[:notice] = "お気に入りを変更しました"
    else
      flash[:notice] = "お気に入りを変更できませんでした"
    end
    redirect_to info_type_reserves_path
  end
  private
  def get_favorite
    @favorite = Favorite.find_by(uaccount_id: current_uaccount.id, oaccount_id: params[:oaccount_id])
  end

end
