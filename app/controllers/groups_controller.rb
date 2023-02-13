class GroupsController < ApplicationController
  before_action :logged_in_user, only: [:index, :create, :show, :add, :remove, :destroy]
  # before_action :correct_user, only: :destroy

  def index
    @groups = get_group_name(current_user.groups)
    @group = Group.new
  end

  def create
    @group = current_user.groups.create(group_params.merge(create_user_id: current_user.id))
    if @group.save
      flash[:success] = "作成しました。"
      redirect_to groups_path
    else
      flash[:danger] = "登録に失敗しました。もう一度、入力をお確かめの上ご登録お願いします。"
      redirect_to groups_path
    end
  end

  def show
    @group = Group.find(params[:id])
    @members = @group.users
    @member = Member.new

    @group_work = GroupWork.new
  end


  def add
    @group = Group.find(params[:id])
    @add_user = User.find_by(email: params[:email])
    if @add_user
      flash[:success] = @add_user.name + "を"+ @group.name + "に追加しました。"
      @add_user.groups << @group
    else
      flash[:info] = "ユーザーが見つかりませんでした。入力を確認の上、もう一度お試しください。"
    end
    redirect_to group_path(@group)
  end

  def remove
    @members = Member.where(group_id: params[:id])
    @member = @members.find_by(user_id: params[:user_id])
    @user = User.find(params[:user_id])
    @group = Group.find(params[:id])
    flash[:success] = @user.name + "を" + @group.name +  "から削除しました。"
    @member.destroy
    redirect_to groups_path
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:success] = '削除しました。'
    redirect_to groups_path
  end


  private

  def group_params
    params.require(:group).permit(:name)
  end

  def get_group_name(members)
    admin_groups = []
    not_admin_groups = []
    members.each do |member|
      if member[:create_user_id] == current_user.id
        admin_groups << member
      else
        not_admin_groups << member
      end
    end
    return admin_groups, not_admin_groups
  end
end
