class Oaccounts::NoticesController < ApplicationController
  before_action :authenticate_oaccount!
  before_action :get_notice, only: [:destroy]
  def index
    id = current_oaccount&.id
    @notices = OaccountNotice.where(oaccount_id: id, checked_at: nil).order(created_at: "ASC")
  end
  def destroy
    @notice.check
    redirect_to oaccounts_notices_path
  end
private
  def get_notice
    @notice = OaccountNotice.find(params[:id])
  end
end
