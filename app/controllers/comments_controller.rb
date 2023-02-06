class CommentsController < ApplicationController
  before_action :get_comment,only: [ :destroy ]
  def create
    comment = Comment.new(comment_params)
    reserve_id = params[:reserf_id] || params[:reserve_self_id]
    reserve = ReserveDate.find(reserve_id)
    unless reserve.user_match?(current_oaccount, current_uaccount)
      flash[:notice] = "不正なアクセスです"
      redirect_to "/"
      return
    end
    comment.reserve_date_id = reserve_id
    if @user_in
      comment.uaccount_id = current_uaccount.id
      comment.sender_flg = "uaccount_comment"
      comment.uaccount_read_at = Time.zone.now
    else
      comment.oaccount_id = current_oaccount.id
      comment.sender_flg = "oaccount_comment"
      comment.oaccount_read_at = Time.zone.now
    end

    if comment.save
      flash[:notice] = "コメントを送信しました"
    else
      flash[:notice] = "コメントを送信できませんでした"
    end
    if @user_in
      redirect_to reserve_show_reserf_path(comment.reserve_date_id)
    else
      redirect_to reserve_show_reserve_self_path(comment.reserve_date_id)
    end
  end

  def destroy
    if @comment.delete
      flash[:notice] = "コメントを削除しました"
    else
      flash[:notice] = "コメントが削除できませんでした"
    end
    if @user_in
      redirect_to reserve_show_reserf_path(@comment.reserve_date_id)
    else
      redirect_to reserve_show_reserve_self_path(@comment.reserve_date_id)
    end
  end

  private
  def get_comment
    comment=Comment.find(params[:id])
    unless comment.sender_user_match?(current_oaccount, current_uaccount)
      flash[:notice] = "不正なアクセスです"
      redirect_to "/"
      return
    end
    @comment=comment
  end


  def comment_params
    params.require(:comment).permit(:comment)
  end
end
