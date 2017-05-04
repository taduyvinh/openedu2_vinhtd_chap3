class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @title = params[:title]
    follow = ["following", "followers"]
    @user = User.find_by id: params[:user_id]
    if @user.nil?
      flash[:error] = t "user_not_found"
      redirect_to root_path
    elsif follow.exclude? @title
      flash[:error] = t "title_error"
      redirect_to @user
    else
      @users = @user.send(@title).paginate page: params[:page]
      render "users/show_follow"
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to user_path}
        format.js
      end
      @unfollow = current_user.active_relationships.find_by(
        followed_id: @user.id)
    else
      flash[:error] = t "user_not_found"
      redirect_to root_path
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to user_path}
      format.js
    end
    @follow = current_user.active_relationships.build
  end
end
