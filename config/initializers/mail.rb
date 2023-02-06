ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  # address のところは変更しないので注意。自分はここでハマりました。
  address: 'email-smtp.ap-northeast-1.amazonaws.com',
  domain: 'picot.jp',
  port: 587,
  # user_name は自分のメールアドレスを記載。
  user_name: 'AKIAVDWIW6JJIQX5GV6V',
  # password は作成したアプリパスワードを記載。
  password: 'BD8QRYxsnuKBU2mz3mMh6sDQNcSTQKFrlAoLgJvHCL8S',
  authentication: 'plain',
  enable_starttls_auto: true
}
