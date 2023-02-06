class MattersController < ApplicationController
  before_action :authenticate_uaccount!
  before_action :get_matter,only: [:show, :edit, :edit_confirm, :destroy_confirm, :destroy, :update]
  before_action :build_matter, only: [:confirm, :create]
  before_action :check_uaccount, only: [:create, :update, :destroy]
  def index
    @matters=Matter.where(uaccount_id: current_uaccount.id, end_date: Date.today..Date.today.months_since(3)).order(start_date: "ASC").page(params[:page]).per(10)
  end
  def new
    @matter=Matter.new
    @matter.uaccount_id = current_uaccount.id
    @matter.end_reception_flg = "reception"
  end
  def confirm
    if @matter.start_date >= @matter.end_date
      flash.now[:notice] = "予約開始日と終了日の日付をご確認ください"
      render :new
    end
  end
  def create
    if Matter.create(update_params)
      flash[:notice] = "依頼ボードに登録されました"
      redirect_to matters_path
    else
      flash[:notice] = "依頼ボードに登録されませんでした"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def edit_confirm
    @matter.assign_attributes(update_params)
    if @matter.start_date >= @matter.end_date
      flash[:notice] = "予約開始日と終了日の日付をご確認ください"
      render :edit
    end
  end
  def update
    if @matter.update(update_params)
      flash[:notice] = "予約が変更されました"
      redirect_to matters_path
    else
      flash[:notice] = "予約が変更できませんでした。#{@matter.errors.messages.values.join(",")}"
      render :edit
    end
  end
  def destroy_confirm
  end
  def destroy
    if @matter.destroy
      flash[:notice] = "予約が削除されました"
      redirect_to matters_path
    else
      flash[:notice] = "予約が削除されませんでした"
      redirect_to matters_path
    end
  end

private
  def get_matter
    @matter=Matter.find(params[:id])
  end
  def update_params
    params.require(:matter).permit(:uaccount_id, :start_date, :end_date, :remark, :end_reception_flg )
  end
  def check_uaccount
    if @matter.uaccount_id != current_uaccount.id
      flash[:notice] = "不正なアクセスです"
      render :new
      return
    end
  end
  def build_matter
    @matter = Matter.new(update_params)
  end
end
