class UserMailer < ApplicationMailer
  default from: 'admin@picot.jp'

  # ここのメソッド名をメール文面の view ファイルの名前にする。
  # user と url は呼び出し元の コントローラーのメソッドから渡される。
  def user_create(uaccount)
    # @user, @url に値を入れて view に渡す。
    @uaccount = uaccount
    mail(to: uaccount.email, subject: "予約が完了しました")
  end


end
