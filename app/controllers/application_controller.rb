class ApplicationController < ActionController::Base
  before_action :set_office_signed_in_status
  before_action :set_user_signed_in_status
  before_action :set_administrator_signed_in_status
  before_action :set_menu_bar
  before_action :set_sub_menu_bar
  def set_office_signed_in_status
    @office_in = oaccount_signed_in?
  end

  def set_administrator_signed_in_status
    @administrator_in = administrator_signed_in?
  end
  def set_user_signed_in_status
    @user_in = uaccount_signed_in?
  end
  def set_menu_bar
    @menu_bar = if @office_in
      [
        [main_path(current_oaccount.id), "事業者情報"],
        [oaccounts_notices_path, "お知らせ一覧"],
        [reserve_self_path(current_oaccount.id), "予約状況"],
        [permit_index_reserve_self_path(current_oaccount.id), "承認した予約"],
        [decline_index_reserve_self_path(current_oaccount.id), "非承認した予約"]
      ]
    elsif @user_in
      [
        [user_path(current_uaccount.id), "ケアマネ情報"],
        [uaccounts_notices_path, "お知らせ一覧"],
        [info_type_reserves_path, "ベッド種類で検索"],
        [service_date_reserves_path, "日付ベッド検索"]
      ]
    else
      [
        [main_index_path, "ホーム"],
        [info_type_main_index_path, "ベッドの種類で検索"],
        [privacy_policy_main_index_path, "プライバシーポリシー"]
        # [map_main_index_path,"map"]
      ]
    end
  end
  def set_sub_menu_bar
    @sub_menu_bar = if @office_in
      [
        [bed_article_office_path(current_oaccount.id), "空き状況の確認"],
        [bed_article_edit_office_path(current_oaccount.id), "ベッド数の変更"],
        [history_index_reserve_self_path(current_oaccount.id), "過去3ヵ月履歴"],
        [month_total_reserve_self_path(current_oaccount.id), "統計資料"]
      ]
    elsif @user_in
      [
        [reserves_path, "予約一覧"],
        [permit_index_reserves_path, "承認済一覧"],
        [decline_index_reserves_path, "非承認一覧"],
        [history_index_reserves_path, "過去３カ月の予約"],
        [favorite_index_reserves_path, "お気に入り事業所"],
        [matters_path, "依頼ボードに記入"]
      ]
    else
      [
        [faq_main_index_path, "よくある質問"],
        [contact_main_index_path, "お問い合わせ"]
      ]
    end
  end
end
