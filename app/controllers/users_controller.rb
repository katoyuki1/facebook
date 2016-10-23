class UsersController < ApplicationController
  def index
    @users = User.all
    @followed = current_user.followed_users
    @followers = current_user.followers
  end

  def show
    @user = User.find(params[:id])
  end
end
