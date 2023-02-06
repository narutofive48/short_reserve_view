class Uaccounts::NoticesController < ApplicationController
  before_action :authenticate_uaccount!
  before_action :get_notice, only: [:destroy]
  def index
    id = current_uaccount&.id
    @notices = UaccountNotice.where(uaccount_id: id, checked_at: nil).order(created_at: "ASC")
  end
  def destroy
    @notice.check
    redirect_to uaccounts_notices_path
  end
private
  def get_notice
    @notice = UaccountNotice.find(params[:id])
  end
end
