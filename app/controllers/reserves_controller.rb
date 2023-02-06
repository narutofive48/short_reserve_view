class ReservesController < ApplicationController
  before_action :authenticate_uaccount!
  before_action :get_reserve,only: [:delete_confirm, :delete, :edit, :edit_confirm, :edit_update, :delete, :permit_reserf, :reserve_show]
  def index
    @reserves=ReserveDate.where(user_id: current_uaccount.id, entry_flg: "no_entry_status", end_date: Date.today..Float::INFINITY).order(start_date: "ASC").page(params[:page]).per(10)
  end
  def permit_index
    @reserves=ReserveDate.where(user_id: current_uaccount.id, entry_flg: "entry_status", end_date: Date.today..Float::INFINITY).order(start_date: "ASC").page(params[:page]).per(10)
  end
  def decline_index
    @reserves=ReserveDate.where(user_id: current_uaccount.id, entry_flg: "decline_status", end_date: Date.today..Float::INFINITY).order(start_date: "ASC").page(params[:page]).per(10)
  end
  def history_index
    @reserves=ReserveDate.where(user_id: current_uaccount.id, end_date: Date.today.months_ago(3)..Date.today).order(start_date: "ASC").page(params[:page]).per(10)
  end
  def comment_index
    @reserves=ReserveDate.joins(:comments).where(user_id: current_uaccount.id, comments: { uaccount_read_at: nil }).order(start_date: "ASC").page(params[:page]).per(10)
  end
  def info_type
    @q = Oaccount.visible.order(display_sort: "DESC").page(params[:page]).per(10).ransack(params[:q])
    @oaccounts = @q.result(distinct: true)
    @favorite_oaccount_ids = Favorite.oaccount_ids(current_uaccount.id)
  end

  def favorite_index
    @favorite_oaccount_ids = Favorite.oaccount_ids(current_uaccount.id)
    @q = Oaccount.preload(:bed_type, :office_city, {thumbnail_attachment: :blob}).where(id: @favorite_oaccount_ids).visible.order(display_sort: "DESC").ransack(params[:q])
    @oaccounts = @q.result(distinct: true)
  end

  def service_date
    ransack_params=params[:q]
    begin_date = params.dig(:q, :reserve_counts_date_gteq)
    end_date = params.dig(:q, :reserve_counts_date_lteq)

    %i[gteq lteq].map { |s| "reserve_counts_date_#{s}".to_sym }.each do |key|
      next unless ransack_params.present? && ransack_params[key]
      ransack_params.delete(key)
    end
    @q = Oaccount.preload(:bed_type, :office_city, {thumbnail_attachment: :blob}).visible
         .order(display_sort: "DESC").select("oaccounts.*").join_reserve_counts(begin_date, end_date)
         .ransack(params[:q])
    @oaccounts = if begin_date.present? && end_date.present?
      @q.result(distinct: true).where("office_bed_count > ?", 0).group(:id).having("COUNT(reserve_counts.last_count<=0 OR null)<=0")
    else
      @q.result(distinct: true).group(:id)
    end
    @favorite_oaccount_ids = Favorite.oaccount_ids(current_uaccount.id)
  end


  def reserve_show
    @reserve.uaccount_comment_read
    if Comment.where(reserve_date_id: @reserve.id, deleted_at: nil) then
      @comments = Comment.where(reserve_date_id: @reserve.id, deleted_at: nil)
    end
  end


  def new
    @reserve=ReserveDate.new
    @reserve.office_id = params[:office_id] if params[:office_id].present?
    start_date = Date.parse(params[:date]) if params[:date]&.match?(/^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$/)
    if start_date.present?
      @reserve.start_date=start_date
      @reserve.end_date=start_date.next
    else
      @reserve.start_date=Date.today
      @reserve.end_date=Date.today.next
    end
    if current_uaccount
      @reserve.user_id=current_uaccount.id
    else
      flash[:notice]="ログインしてから予約をお願い致します"
      redirect_to info_path
    end
    @reserve.entry_flg = "no_entry_status"
  end
  def create
    @reserve = ReserveDate.new(update_params)
    if @reserve.save
      # ReserveMailer.uaccount_reserve(@reserve).deliver
      # ReserveMailer.oaccount_reserve(@reserve).deliver
      # ReserveMailer.admin_reserve(@reserve).deliver
      flash[:notice] = "予約が保存されました"
      # oaccount_notice 書き込み
      @reserve.reserve_notice!

      redirect_to reserves_path
    else
      flash.now[:notice] = "予約できませんでした。#{@reserve.errors.messages.values.join(",")}"
      render :new
    end
  end
  def confirm
    @reserve = ReserveDate.new(update_params)
    if @reserve.start_date >= @reserve.end_date
      flash.now[:notice] = "予約開始日と終了日の日付をご確認ください"
      render :new
    end
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
      redirect_to reserf_path
    else
      flash[:notice] = "予約が変更できませんでした。#{@reserve.errors.messages.values.join(",")}"
      render :edit
    end
  end

  def delete_confirm
  end

  def delete
    if @reserve.destroy
      flash[:notice] = "予約が削除されました"
      redirect_to reserf_path
    else
      flash[:notice] = "予約が削除されませんでした"
      redirect_to reserf_path
    end
  end

  def bed_show


    @oaccount=Oaccount.find(params[:id])

    @calendars = (1..(@oaccount.max_reservation_months)).map do |i|
      Date.today.beginning_of_month.next_month(i-1)
    end.map do |d|
      end_of_month = d.end_of_month
      {
        month: d.month,
        beginning_of_month: d,
        reserve_statuses: @oaccount.reserve_statuses(d, end_of_month),
        beginning_of_calender: d.ago(d.wday.day).to_date,
        end_of_calender: end_of_month.since((6 - end_of_month.wday).day)
      }
    end

  end
private
    def get_reserve
      @reserve=ReserveDate.find(params[:id])
    end
    def update_params
      params.require(:reserve_date).permit(:office_id, :start_date, :start_transfer_id, :end_date, :end_transfer_id, :past_use_id, :entry_flg, :remark, :user_id, :reserve_code, :client_name )
    end
    def update_oaccount_notice
      params.require(:oaccount_notice).permit(:oaccount_id, :begin_at, :end_at, :notice_text, :checked_at, :link_to)
    end
  end
