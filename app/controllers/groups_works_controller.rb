class GroupsWorksController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @group_work = current_user.group_works.build(groups_work_params.merge(group_id: params[:group_id]))

    if @group_work[:time_hour] == 0 and @group_work[:time_minute] == 0
      flash[:danger] = "0分の行動時間は登録できません。もう一度、入力をお確かめの上ご登録お願いします。"
      redirect_to group_path(@group_work.group_id)
      return
    end

    if @group_work.save
      @group = Group.find(params[:group_id])
      flash[:success] = @group.name + "に行動時間を登録にしました。"
      redirect_to group_path(@group_work.group_id)
    else
      flash[:danger] = "登録に失敗しました。もう一度、入力をお確かめの上ご登録お願いします。"
      redirect_to group_path(@group_work.group_id)
    end
  end

  def destroy
    @group_work = GroupWork.find(params[:id])
    group_id = @group_work.group_id
    @group_work.destroy
    flash[:success] = '削除しました。'
    redirect_to group_path(group_id)
  end


  private

  def groups_work_params
    params.require(:group_work).permit(:time_hour, :time_minute, :date)
  end
end
