class PasswordResetsController < ApplicationController
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_password_digest
      @user.send_password_reset_email
      flash[:info] = t "email_sent"
      redirect_to root_path
    else
      flash.now[:error] = t "email_not_found"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("cant_empty")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "reset_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def valid_user
    @user = User.find_by email: params[:email]
    unless @user && @user.activated? &&
      @user.authenticated?(:reset, params[:id])
      redirect_to root_path
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:error] = t "password_expired"
      redirect_to new_password_reset_url
    end
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
