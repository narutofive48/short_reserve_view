class OfficesController < ApplicationController

  before_action :get_oaccount,only: [:bed_show, :bed_article, :edit, :confirm, :update]
  def index
    @oaccounts = Oaccount.all

  end

  def bed_article
    @oaccount=Oaccount.find(params[:id])

    @calendars = (1..(@oaccount.max_reservation_months)).map do |i|
      Date.today.beginning_of_month.next_month(i - 1)
    end.map do |d|
      end_of_month = d.end_of_month
      {
        month: d.month.month,
        beginning_of_month: d,
        end_of_month: end_of_month,
        reserve_statuses: @oaccount.reserve_statuses(d, end_of_month),
        beginning_of_calender: d.ago(d.wday.day).to_date,
        end_of_calender: end_of_month.since((6-end_of_month.wday).day)
      }
    end
  end

  def bed_article_edit
    bed_article
    @forms = ReserveCount.reserve_count_models([@calendars.first[:beginning_of_month], Date.today].max, @calendars.last[:end_of_month], @oaccount)
  end

  def bed_article_confirm
    bed_article_edit
    params_hash=update_disable_bed_count_params[:reserve_counts].to_h.map{|k, v|[Date.parse(v[:date]), v[:disable_bed_count].to_i]}.to_h
    @forms.each do |k, v|
      v.disable_bed_count=params_hash[k]
    end

  end

  def bed_article_update
    bed_article_confirm
    ActiveRecord::Base.transaction do
      @forms.values.each(&:save_disable_bed_count!)
    end
    redirect_to bed_article_office_path(current_oaccount.id)
  end

  def confirm
    @oaccount.assign_attributes(update_params)
    @oaccount.attachment_changes["thumbnail"]&.save
    @oaccount.attachment_changes["pdf_info"]&.save
  end

  def edit

  end

  def update
    @oaccount.update(update_params)
    flash[:notice] = "事業所情報が更新されました"
    redirect_to main_path(@oaccount.id)
  end

  def login_form

  end

  def create
  end

  def reserve_index
  end

  private
    def get_oaccount
      id=current_oaccount&.id || params[:id]
      @oaccount=Oaccount.eager_load(office_city: :prefecture).find(id)
    end
    def update_params
      params.require(:oaccount).permit(:office_num, :max_reservation_months, :medical_practice, :trance_area,
         :address, :startday, :thumbnail, :office_name, :email, :office_city_id, :office_phone, :office_url,
          :office_bed_count, :office_bed_type, :office_apear, :pdf_info, :fax_num, :bed_type2_id)
    end
    def update_disable_bed_count_params
      params.require(:reserve_counts).permit(reserve_counts: [:disable_bed_count, :date])
    end
end
