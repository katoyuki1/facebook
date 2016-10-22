class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  
  def index
    @topics = Topic.all.order(created_at: :desc)
    @topic = Topic.new
    @users = User.all
    @followed = current_user.followed_users
    @followers = current_user.followers
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topics_params)
    @topic.user_id = current_user.id
    if @topic.save
      redirect_to topics_path, notice: "投稿しました！"
      NoticeMailer.sendmail_topic(@topic).deliver
    else
      
      render action: 'new'
    end
  end
  
  def show
    @comment = @topic.comments.build
    @comments = @topic.comments
    Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
  end  
  
  def edit
  end

  def update
    @topic.update(topics_params)
    redirect_to topics_path
  end
  
  def destroy
    @topic.destroy
    redirect_to topics_path, notice: "削除しました！"
  end
  private
    def topics_params
      params.require(:topic).permit(:content)
    end
    
    def set_topic
      @topic = Topic.find(params[:id])
    end
end
