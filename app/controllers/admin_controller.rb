class AdminController < ApplicationController
  before_action :authenticate_administrator!
  before_action :get_city, only: [:edit_city, :update_city, :delete_city, :confirm_delete_city]
  before_action :get_office, only: [:delete_office, :edit_office, :confirm_office, :update_office, :delete_office_confirm]
  before_action :get_bedtype, only: [:edit_bedtype, :update_bedtype, :delete_bedtype]
  before_action :get_uaccount, only: [:delete_uaccount, :delete_uaccount_confirm]
  before_action :get_reserve, only: [:reserve_show]
  def top
  end
  def reserve_log_index
  end
  def uaccount_index
    @uaccounts = Uaccount.all
  end
  def delete_uaccount_confirm
  end
  def delete_uaccount
    if @uaccount.destroy
      flash[:notice] = "ケアマネが削除されました"
    else
      flash[:notice] = "ケアマネが削除されませんでした"
    end
    redirect_to uaccount_index_admin_index_path
  end
  def city_index
    @cities = City.all
  end
  def confirm_delete_city
  end
  def new_city
    @city=City.new
  end
  def new_city_update
    @city=City.new(update_params_city)
    if @city.save
        flash[:notice] = "地区が追加されました"
      redirect_to city_index_admin_index_path
    else
      flash[:notice] = "地区が追加できませんでした"
      render :new_city
    end
  end
  def edit_city
  end
  def update_city
    if @city.update(update_params_city)
      flash[:notice] = "地区が更新されました"
      redirect_to  city_index_admin_index_path
    end
  end
  def delete_city
    if @city.destroy
      flash[:notice] = "地区が削除されました"
    else
      flash[:notice] = "地区が削除されませんでした"
    end
    redirect_to city_index_admin_index_path
  end
  def info_delete
    @q = Oaccount.ransack(params[:q])
    @oaccounts = @q.result(distinct: true)
  end
  def edit_office
  end
  def confirm_office
    @oaccount.assign_attributes(update_params_office)
    @oaccount.attachment_changes["thumbnail"]&.save
  end
  def update_office
    if @oaccount.update(update_params_office)
      flash[:notice] = "事業所の情報が更新されました"
      redirect_to  info_delete_admin_index_path
    else
      flash[:notice] = "事業所が更新されませんでした"
      redirect_to info_delete_admin_index_path
    end
  end
  def delete_office_confirm
  end
  def delete_office
    if @oaccount.destroy
      flash[:notice] = "事業所が削除されました"
      redirect_to info_delete_admin_index_path
    else
      flash[:notice] = "事業所が削除されませんでした"
      redirect_to info_delete_admin_index_path
    end
  end
  def new_bedtype
    @bedtype = Bedtype.new
  end
  def new_bedtype_update
    @bedtype=Bedtype.new(update_params_bedtype)
    if @bedtype.save
      flash[:notice] = "ベッドの種類が追加されました"
      redirect_to bedtype_index_admin_index_path
    else
      flash[:notice] = "ベッドの種類が追加できませんでした"
      render :new_bedtype
    end
  end
  def bedtype_index
    @bedtypes = Bedtype.all
  end
  def edit_bedtype
  end
  def update_bedtype
    if @bedtype.update(update_params_bedtype)
      flash[:notice] = "ベッドの種類が更新されました"
      redirect_to  bedtype_index_admin_index_path
    end
  end
  def delete_bedtype
    if @bedtype.destroy
      flash[:notice] = "ベッドの種類が削除されました"
    else
      flash[:notice] = "ベッドの種類が削除されませんでした"
    end
    redirect_to bedtype_index_admin_index_path
  end
  def mail_all_send
    # @sendmail = Sendmail.new
  end
  def mail_all_send_confirm
    # @sendmail = Sendmail.new(sendmail_params)
  end
  def all_uaccounts_send
    # @sendmail = Sendmail.new(sendmail_params)
    # @sendmail.send_mail
    flash[:notice] = "メールが送信されました"
    redirect_to  top_admin_index_path
  end
  def reserves_index
    @reserves = ReserveDate.all.page(params[:page]).per(10)
  end
  def reserve_show
    @reserve.uaccount_comment_read
    if Comment.where(reserve_date_id: @reserve.id, deleted_at: nil) then
      @comments = Comment.where(reserve_date_id: @reserve.id, deleted_at: nil)
    end
  end
private
  def get_city
    @city = City.find(params[:id])
  end
  def update_params_city
    params.require(:city).permit(:city_name, :prefecture_id)
  end
  def get_office
    id=current_oaccount&.id || params[:id]
    @oaccount=Oaccount.eager_load(office_city: :prefecture).find(id)
  end
  def update_params_office
    params.require(:oaccount).permit(:fax_num, :office_num, :paid_oaccount,
      :max_reservation_months, :display_sw, :display_sort, :medical_practice,
      :trance_area, :address, :startday, :thumbnail, :office_name, :email,
      :office_city_id, :office_phone, :office_url, :office_bed_count,
      :office_bed_type, :office_apear, :bed_type2_id)
  end
  def get_bedtype
    @bedtype=Bedtype.find(params[:id])
  end
  def update_params_bedtype
    params.require(:bedtype).permit(:bed_type)
  end
  def get_uaccount
    @uaccount = Uaccount.find(params[:id])
  end
  def sendmail_params
    params.require(:sendmail).permit(:text, :subject)
  end
  def get_reserve
    @reserve = ReserveDate.find(params[:id])
  end

end
