class ReserveDate < ApplicationRecord
  enum entry_flg: { no_entry_status: 0, entry_status: 1, decline_status: 2}
  belongs_to :oaccount, class_name: "Oaccount", foreign_key: "office_id"
  belongs_to :uaccount, class_name: "Uaccount", foreign_key: "user_id", optional: true
  belongs_to :start_transfer, class_name: "Transfer", foreign_key: "start_transfer_id"
  belongs_to :end_transfer, class_name: "Transfer", foreign_key: "end_transfer_id"
  belongs_to :past_use, class_name: "Past", foreign_key: "past_use_id"
  has_many :comments
  validates :reserve_code, uniqueness: true
  validate :validate_reserve_count
  validate :validate_over_month, on: :create
  validate :validate_year_over
  after_initialize :set_reserve_code
  def reserve
    # return false unless new_record?
    # self.class.transaction do
    #   return false unless save
    # end
  end
  def entry!
    self.class.transaction do
      lock!
      reload
      raise ReserveStatusError.new if entry_status?
      self.entry_flg="entry_status"
      save!
      dates.each do |date|

        ReserveCount.reserve!(oaccount,date)
      end
      return if user_id.blank?
      UaccountNotice.create!(
        uaccount_id: user_id,
        begin_at: Time.zone.now,
        notice_text: "#{oaccount.office_name}様から予約が承認されました",
        link_to: Rails.application.routes.url_helpers.permit_index_reserves_path
      )
    end
  end


  def cancel!
    self.class.transaction do
      lock!
      reload
      raise ReserveStatusError.new unless entry_status?
      self.entry_flg="no_entry_status"
      save!
      dates.each do |date|
        ReserveCount.cancel!(oaccount,date)
      end
    end
  end
#   最終日をカウントしないメソッド
  def reserve_end_date
    return end_date.ago(1.day).to_date
    end_date
  end

  def display_user_name
    uaccount&.user_name || user_name
  end

  def display_user_phone
    uaccount&.user_phone || user_phone
  end

  def display_user_office
    uaccount&.user_office
  end

  def user_match?(oaccount, uaccount)
    return self.oaccount.id == oaccount&.id if self.uaccount.blank?
    self.uaccount.id == uaccount&.id || self.oaccount.id == oaccount&.id
  end

  def uaccount_comment_read
    comments.reject(&:uaccount_comment_read?).each(&:uaccount_comment_read)
  end
  def oaccount_comment_read
    comments.reject(&:oaccount_comment_read?).each(&:oaccount_comment_read)
  end

  def decline!
    decline_status!
    return if user_id.blank?
    UaccountNotice.create!(
      uaccount_id: user_id,
      begin_at: Time.zone.now,
      notice_text: "#{oaccount.office_name}様から予約が非承認になりました",
      link_to: Rails.application.routes.url_helpers.decline_index_reserves_path
    )
  end
  def reserve_notice!
    return if office_id.blank?
    OaccountNotice.create!(
      oaccount_id: office_id,
      begin_at: Time.zone.now,
      notice_text: "#{uaccount.user_name}様からショートステイの予約が入っています",
      link_to: Rails.application.routes.url_helpers.reserve_self_path(office_id)
    )
  end



  private
    def dates
      results=[]
      i=start_date
      while i <= reserve_end_date do
        results << i
        i = i.next
      end
      results
    end

    def set_reserve_code
      self.reserve_code||=SecureRandom.uuid
    rescue
    end
    def validate_reserve_count
      return if entry_flg_in_database == "entry_status"
      return if entry_flg == "decline_status"
      return if reserve_counts.all? { |k,v| v.positive? }
      errors.add(:start_date, "予約ベッドが空いていません")
    end
    def reserve_counts
      ReserveCount.reserve_counts(start_date, reserve_end_date, oaccount)
    end
    def validate_over_month
      since_month = oaccount.max_reservation_months
      return if start_date >= Date.today && start_date < Date.today.beginning_of_month.since(since_month.month)
      errors.add(:start_date, "日付を正しく入力してください")
    end
    def validate_year_over
      return if end_date <= start_date.since(1.year)
      errors.add( :end_date, "期間が長すぎます")
    end
end
