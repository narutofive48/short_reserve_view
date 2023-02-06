class Comment < ApplicationRecord
  belongs_to :reserve_date
  belongs_to :uaccount, optional: true
  belongs_to :oaccount, optional: true
  enum sender_flg: { oaccount_comment: 1, uaccount_comment: 2 }
  validates :comment, presence: true
  after_create :notice

  def sender_user
    oaccount_comment? ? oaccount : uaccount
  end
  def sender_user_match?(oaccount, uaccount)
    (oaccount_comment? ? oaccount : uaccount).id == sender_user.id
  end

  def uaccount_comment_read?
    uaccount_read_at.present?
  end

  def uaccount_comment_read
    return if uaccount_comment_read?
    update(uaccount_read_at: Time.zone.now)
  end

  def oaccount_comment_read?
    oaccount_read_at.present?
  end

  def oaccount_comment_read
    return if oaccount_comment_read?
    update(oaccount_read_at: Time.zone.now)
  end


  def delete
    update(deleted_at: Time.zone.now)
  end
  def notice
    if uaccount_id.present?
      notice_oaccount_id = reserve_date.office_id
      OaccountNotice.create!(
        oaccount_id: notice_oaccount_id,
        begin_at: Time.zone.now,
        notice_text: "#{uaccount.user_name}からコメントが入っています",
        link_to: Rails.application.routes.url_helpers.reserve_show_reserve_self_path(reserve_date_id)
      )
    elsif oaccount_id.present? && reserve_date.user_id.present?
      notice_uaccount_id = reserve_date.user_id
      UaccountNotice.create!(
        uaccount_id: notice_uaccount_id,
        begin_at: Time.zone.now,
        notice_text: "#{oaccount.office_name}からコメントが入っています",
        link_to: Rails.application.routes.url_helpers.reserve_show_reserf_path(reserve_date_id)
      )  
    end
  end
end
