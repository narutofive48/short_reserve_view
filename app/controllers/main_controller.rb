class MainController < ApplicationController
  before_action :get_oaccount,only: [:show]

  def index
    @uaccount = current_uaccount
    @matters = Matter.where(start_date: Date.today..Float::INFINITY).order(start_date: "ASC").limit(5)
    @exist_unread_comment =
      if current_uaccount.present?
        Comment.joins(:reserve_date).where(reserve_dates: {user_id: current_uaccount.id}, uaccount_read_at: nil).exists?
      elsif current_oaccount.present?
        Comment.joins(:reserve_date).where(reserve_dates: {office_id: current_oaccount.id}, oaccount_read_at: nil).exists?
      else
        false
      end
    @notices = if current_uaccount.present?
      UaccountNotice.where(uaccount_id: current_uaccount.id).order(created_at: "DESC").limit(5).displaying
    elsif current_oaccount.present?
      OaccountNotice.where(oaccount_id: current_oaccount.id).order(created_at: "DESC").limit(5).displaying
    else
      []
    end
  end

  def info_type
    @q = Oaccount.visible.order(display_sort: "DESC").page(params[:page]).per(10).ransack(params[:q])
    @oaccounts = @q.result(distinct: true)
  end

  def show
  end


  def faq
  end

  def privacy_policy
  end

  def contact
    @contact = Contact.new
  end

  def contact_confirm
    @contact = Contact.new(contact_params)
  end
  def send_contact
    @contact = Contact.new(contact_params)
    @contact.send_mail
    flash[:notice] = "お問い合わせが送信されました"
    redirect_to main_index_path
  end

  def map
    @q = Oaccount.visible.order(display_sort: "DESC").page(params[:page]).per(10).ransack(params[:q])
    @oaccounts = @q.result(distinct: true)
  end

private
  def get_oaccount
    id = current_oaccount&.id || params[:id]
    @oaccount=Oaccount.eager_load(office_city: :prefecture).find(id)
  end
  def contact_params
    params.require(:contact).permit(:name, :mailaddress, :text)
  end
end
