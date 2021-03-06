class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  
  def create
    @comment = current_user.comments.build(comment_params)
    @topic = @comment.topic
    @notification = @comment.notifications.build(user_id: @topic.user_id)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to topic_path(@topic), notice: 'コメントを投稿しました。' }
        format.json { render :show, status: :created, location: @comment }
        format.js { render :index }
       
        unless @comment.topic.user_id == current_user.id 
          Pusher.trigger("user_#{@comment.topic.user_id}_channel", 'comment_created', {
            message: 'あなたの投稿にコメントが付きました。'
          })
        end
        Pusher.trigger("user_#{@comment.topic.user_id}_channel", 'notification_created', {
          uncreate_count: Notification.where(user_id: @comment.topic.user.id).count
        })
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    @comment.update(comment_params)
    redirect_to topic_path(@comment.topic_id)
  end

  def destroy
    respond_to do |format|
    if @comment.destroy
        format.html { redirect_to topic_path(@topic)}
        format.json { render :show, status: :created, location: @comment }
        format.js { render :index }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
    end
    end
  end
  private
    
    def comment_params
      params.require(:comment).permit(:topic_id, :content)
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
end
