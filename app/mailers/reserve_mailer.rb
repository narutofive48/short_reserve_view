class ReserveMailer < ApplicationMailer
  default from: 'admin@picot.jp'
  def uaccount_reserve(reserve)
    @reserve = reserve
    mail(to: reserve.uaccount.email, subject: "予約のご連絡")
  end
  def uaccount_decline(reserve)
    @reserve = reserve
    mail(to: reserve.uaccount.email, subject: "予約が承認されませんでした")
  end
  def uaccount_permit(reserve)
    @reserve = reserve
    mail(to: reserve.uaccount.email, subject: "予約が承認されました")
  end
  def oaccount_reserve(reserve)
    @reserve = reserve
    mail(to: reserve.oaccount.email, subject: "予約が入りました" )
  end
  def admin_reserve(reserve)
    @reserve = reserve
    mail(to: 'kojima@soudaninblog.com', subject: "ケアマネから事業所に予約が入りました")
  end
end
