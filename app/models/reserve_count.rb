class ReserveCount < ApplicationRecord
  belongs_to :oaccount
  def self.reserve!(oaccount,date)
    item=find_or_initialize_by(oaccount_id: oaccount.id, date: date)
    if item.new_record?
      item.last_count=oaccount.office_bed_count
      item.save!
    end
    item.reserve!
  end
  def reserve!
    raise ShortageBedError.new("空室がありません") unless last_count.positive?
    decrement!(:last_count,1)
  end

  def self.cancel!(oaccount,date)
    item=find_by(oaccount_id: oaccount.id, date: date)
    if item.blank?
      raise StandardError.new("予約データが存在しません")
    end
    item.cancel!
  end

  def cancel!
    increment!(:last_count,1)
  end
  def self.reserve_counts(begin_at,end_at,oaccount)
    # items=where(date: begin_at..end_at,oaccount_id: oaccount.id).pluck(:date, :last_count).to_h
    # default_count=oaccount.office_bed_count
    # i=begin_at
    # while i <= end_at
    #   if oaccount.startday.present? && oaccount.startday > i
    #     items[i]=0
    #   elsif items[i].blank?
    #     items[i]=default_count
    #   end
    #   i=i.since(1.day).to_date
    # end
    # items
    reserve_count_models(begin_at, end_at, oaccount).map{|date, model| [date, model.last_count]}.to_h
  end
  def self.reserve_count_models(begin_at,end_at,oaccount)
    items=where(date: begin_at..end_at,oaccount_id: oaccount.id).index_by(&:date)
    default_count=oaccount.office_bed_count
    i = begin_at
    while i <= end_at
      initialize_count=
        if oaccount.startday.present? && oaccount.startday > i
          0
        else
          nil
        end
      items[i]=ReserveCount.new(date: i, oaccount_id: oaccount.id, last_count: default_count) if items[i].blank?
      items[i].last_count=initialize_count unless initialize_count.nil?
      i=i.since(1.day).to_date
    end
    items
  end
  def save_disable_bed_count!
    unless persisted?
      return if disable_bed_count.zero?
      default_last_count = oaccount.office_bed_count
      default_last_count = 0 if oaccount.startday.present? && oaccount.startday > date
      self.last_count = default_last_count - disable_bed_count
      save!
      return
    else
      diff = disable_bed_count - disable_bed_count_in_database
      return if diff.zero?
      reload
      increment!(:disable_bed_count, diff)
      decrement!(:last_count, diff)
      reload
    end
  end

end
