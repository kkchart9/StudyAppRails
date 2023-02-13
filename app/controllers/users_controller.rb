class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    # 足跡機能の実装(他ユーザーがプロフィールを訪れた回数)
    if @user != current_user
      foot_print_cnt = @user[:foot_print]
      if foot_print_cnt.nil?
        foot_print_cnt = 0
      end
      foot_print_cnt = foot_print_cnt + 1
      @user.update(foot_print: foot_print_cnt)
    end
    @microposts = @user.microposts.paginate(page: params[:page])
    @plans = get_plan_week(Plan.where(user_id: params[:id]))
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.update_columns(activated: true, activated_at: Time.zone.now)
      log_in @user
      # @user.send_activation_email
      # flash[:info] = "Please check your email to activate your account."
      flash[:info] = "新規登録しました。ありがとうございます。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "設定を変更しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :picture)
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか判断
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def get_plan_week(plans)
    plan_week = {}
    plans.each do |plan|
      key = plan[:plan_day_of_week]
      val = (plan[:plan_time_hour]*60) + plan[:plan_time_minute]
      plan_week[key] = val
    end

    return plan_week
  end
end
