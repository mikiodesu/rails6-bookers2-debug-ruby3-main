class PostCommentsController < ApplicationController
  def create
    @book1 = Book.find(params[:book_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.book_id = @book1.id

    if @post_comment.save
      respond_to do |format|
        format.js  # 非同期通信で create.js.erb を返す
      end
    else
      # バリデーション失敗時など（必要に応じて）
      respond_to do |format|
        format.js { render js: "alert('コメントの投稿に失敗しました');" }
      end
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end