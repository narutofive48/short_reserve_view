class Oaccount < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :office_city, class_name: "City", foreign_key: :office_city_id
  belongs_to :bed_type, class_name: "Bedtype", foreign_key: :office_bed_type, optional: true
  belongs_to :bed_type2, class_name: "Bedtype", foreign_key: :bed_type2_id, optional: true
  enum display_sw: { no_display_status: 0, display_status: 1}
  enum paid_oaccount: { no_paid_oaccount: 0, paid_oaccount: 1}
  has_many :reserve_counts
  has_one_attached :thumbnail
  has_one_attached :pdf_info
  has_many :favorites, dependent: :destroy
  scope :visible, -> { where(display_sw: 1) }
  def reserve_counts(begin_at, end_at)
    ReserveCount.reserve_counts(begin_at, end_at, self)
  end
  def reserve_statuses(begin_at, end_at)
    reserve_counts(begin_at, end_at).map do |key, value|
      [
        key,
        {
          count: value,
          status: count_status(value)
        }
      ]
    end.to_h
  end
  def impossible_reserve_by_count?(count)
    !count.positive?
  end
  def few_count?(count)
    return false if impossible_reserve_by_count?(count)
    count <= 3
  end
  def count_status(count)
    return "×" if impossible_reserve_by_count?(count)
    return "△" if few_count?(count)
    "○"
  end
  def self.join_reserve_counts(begin_date, end_date)
    joins_sql = "LEFT JOIN reserve_counts reserve_counts ON reserve_counts.oaccount_id=oaccounts.id"
    joins_sql = "#{joins_sql} AND reserve_counts.date >= ?" if begin_date.present?
    joins_sql = "#{joins_sql} AND reserve_counts.date <= ?" if end_date.present?
    joins_sql = Oaccount.sanitize_sql_array([joins_sql, [begin_date,end_date].compact].flatten)
    joins(joins_sql)
  end
end
