class UsersController < ApplicationController
  before_action :get_uaccount, only: [:show, :edit, :confirm, :update]

  def new
  end

  def show
  end

  def confirm
    @uaccount.assign_attributes(update_params)
  end

  def update
    @uaccount.update(update_params)
    if @uaccount.save
      flash[:notice] = "保存されました"
      redirect_to user_path(@uaccount.id)
    else
      flash[:notice] = "e-mailを入れてください"
      render("users/edit")
    end
  end

  def create
  end

  def edit
  end

  def destroy
  end

  def login_check
    @uaccount = current_uaccount
    @msg = 'you logined at: ' + (@uaccount&.current_sign_in_at&.to_s||"")
  end


  private
    def get_uaccount
      id=current_uaccount&.id || params[:id]
      @uaccount=Uaccount.find(id)
    end
    def update_params
      params.require(:uaccount).permit(:user_name, :email, :user_office, :user_phone, :commerce)
    end
end
