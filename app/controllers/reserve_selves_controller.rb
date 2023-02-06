class ReserveSelvesController < ApplicationController
  before_action :authenticate_oaccount!
  before_action :get_reserve,only: [:permit_confirm, :cancel_confirm, :edit, :edit_confirm, :edit_update, :decline_confirm, :decline, :decline_cancel_confirm, :decline_cancel, :permit, :reserve_show ]
  before_action :get_matter, only: [:matter_show]

  def index
    id=current_oaccount&.id
    @reserves=ReserveDate.where(office_id: id, entry_flg: "no_entry_status", end_date: Date.today..Float::INFINITY).order(start_date: "ASC").page(params[:page]).per(10)
  end
  def decline_index
    id=current_oaccount&.id
    @reserves=ReserveDate.where(office_id: id, entry_flg: "decline_status", end_date: Date.today..Float::INFINITY).order(start_date: "ASC").page(params[:page]).per(10)
  end
  def history_index
    id=current_oaccount&.id
    @reserves=ReserveDate.where(office_id: id, end_date: Date.today.months_ago(3)..Date.today).order(start_date: "ASC").page(params[:page]).per(10)
  end
  def permit_index
    id=current_oaccount&.id
    @condition = ReserveSearchCondition.new(search_params)

    @reserves=ReserveDate.where(office_id: id, entry_flg: "entry_status")
    if @condition.date.blank?
      @reserves = @reserves.where(end_date: Date.today..Float::INFINITY)
    else
      @reserves = @reserves.where("start_date <= :date AND :date <= end_date", date: @condition.date)
    end
    @reserves=@reserves.order(start_date: "ASC").page(params[:page]).per(10)
  end
  def comment_index
    id = current_oaccount&.id
    @reserves=ReserveDate.joins(:comments).where(office_id: id, comments: { oaccount_read_at: nil }).order(start_date: "ASC").page(params[:page]).per(10)
  end
  def month_total
    id=current_oaccount&.id
    @reserves = {}
    (0..4).each do |i|
      start_date = Date.today.beginning_of_month.ago(i.month)
      end_date = start_date.since(1.month)
      @reserves[start_date]=ReserveDate.where(office_id: id, start_date: start_date...end_date).order(user_id: "DESC").group(:user_id).select("user_id, count(*) count, sum(datediff(end_date,start_date)) days")
    end
    @uaccounts = Uaccount.where(id: @reserves.values.flatten.map(&:user_id)).index_by(&:id)
  end

  def reserve_show
    @reserve.oaccount_comment_read
    if Comment.where(reserve_date_id: @reserve.id, deleted_at: nil) then
      @comments = Comment.where(reserve_date_id: @reserve.id, deleted_at: nil)
    end
  end

  def cancel_confirm
  end

  def cancel
    begin
      ReserveDate.find(params[:id]).cancel!
    rescue ReserveStatusError => exception
      flash[:notice] = "キャンセルできませんでした。"
      redirect_to reserve_self_path
      return
    end
    redirect_to permit_index_reserve_self_path(current_oaccount.id)
  end


  def decline_confirm
  end
  def decline
    begin
      @reserve.decline!
      flash[:notice] = "予約が非承認されました"
      unless @reserve.user_id.nil?
        # ReserveMailer.uaccount_decline(@reserve).deliver
      end
      redirect_to decline_index_reserve_self_path
    rescue
      flash[:notice] = "予約が非承認できませんでした。#{@reserve.errors.messages.values.join(",")}"
      redirect_to decline_index_reserve_self_path(current_oaccount.id)
    end
  end
  def decline_cancel_confirm
  end
  def decline_cancel
    @reserve.entry_flg = "no_entry_status"
    if @reserve.update(update_params)
      flash[:notice] = "非承認が取り消されました"
      redirect_to reserve_self_path
    else
      flash.now[:notice] = "非承認の取り消しができませんでした。#{@reserve.errors.messages.values.join(",")}"
      redirect_to decline_index_reserve_self_path
    end
  end

  def new
    @reserve=ReserveDate.new
    @reserve.office_id=current_oaccount.id
    start_date = Date.parse(params[:date]) if params[:date]&.match?(/^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$/)
    if start_date.present?
      @reserve.start_date=start_date
      @reserve.end_date=start_date.since(1.day)
    end
    @reserve.entry_flg = "no_entry_status"
  end

  def confirm
    @reserve = ReserveDate.new(update_params)
    @reserve.office_id=current_oaccount.id
    if @reserve.start_date >= @reserve.end_date
      flash.now[:notice] = "予約開始日と終了日の日付をご確認ください"
      render :new
    end
  end

  def create
    @reserve = ReserveDate.new(update_params)
    @reserve.office_id=current_oaccount.id
    if @reserve.save
      flash[:notice] = "予約が保存されました"
      redirect_to reserve_self_path(id: current_oaccount.id)
    else
      flash.now[:notice] = "予約できませんでした。#{@reserve.errors.messages.values.join(",")}"
      render :new
    end
  end

  def permit_confirm
  end

  def permit
    begin
      ReserveDate.find(params[:id]).entry!
    rescue ReserveStatusError => exception
      flash[:notice] = "すでに承認済みのため、承認できませんでした"
      redirect_to reserve_self_path
      return
    rescue ShortageBedError => exception
      flash[:notice] = "ベッド数が足りず、承認できませんでした"
      redirect_to reserve_self_path
      return
    end
    flash[:notice] = "予約が承認されました"
    unless @reserve.user_id.nil?
      # ReserveMailer.uaccount_permit(@reserve).deliver
    end
    redirect_to reserve_self_path(current_oaccount.id)
  end

  def edit
  end
  def edit_confirm
    @reserve.assign_attributes(update_params)
    if @reserve.start_date >= @reserve.end_date
      flash[:notice] = "予約開始日と終了日の日付をご確認ください"
      render :edit
    end
  end
  def edit_update
    if @reserve.update(update_params)
      flash[:notice] = "予約が変更されました"
      redirect_to reserve_self_path
    else
      flash[:notice] = "予約が変更できませんでした。#{@reserve.errors.messages.values.join(",")}"
      render :edit
    end
  end
  def matter_show
  end

  private
    def get_reserve
      @reserve=ReserveDate.find(params[:id])
    end
    def get_matter
      @matter=Matter.find(params[:id])
    end

    def update_params
      params.require(:reserve_date).permit(:client_name, :user_name, :user_phone, :office_id, :start_date, :start_transfer_id, :end_date, :end_transfer_id, :past_use_id, :entry_flg, :remark, :user_id, :reserve_code)
    end

    def search_params
      params.require(:reserve_search_condition).permit(:date)
    rescue
      {}
    end

end
