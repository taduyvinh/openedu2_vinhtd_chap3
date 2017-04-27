class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index]
  before_action :admin_user, only: :destroy
  before_action :find_user, except: [:new, :create, :index]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.activated.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_email"
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    unless @user.activated
      flash[:error] = t "account_not_activated"
      redirect_to root_path
    end
    @microposts = @user.microposts.ordered.paginate page: params[:page]
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "updated_user"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "deleted_user"
    redirect_to users_path
  end

  def correct_user
    redirect_to root_path unless @user.current_user? current_user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:error] = t "user_not_found"
      redirect_to root_path
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end
end
