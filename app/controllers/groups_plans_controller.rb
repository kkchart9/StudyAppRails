class GroupsPlansController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @group_plan = GroupPlan.new(groups_plans_params.merge(group_id: params[:group_id]))
    pre_plan_data = GroupPlan.where(group_id: params[:group_id]).find_by(day_of_week: groups_plans_params["day_of_week"], user_id: groups_plans_params["user_id"])

    if @group_plan[:time_hour] == 0 && @group_plan[:time_minute] == 0
      flash[:danger] = "0分の行動予定は登録できません。"
      redirect_to group_path(@group_plan.group_id)
      return
    end

    if pre_plan_data.nil?
      if @group_plan.save
        @group = Group.find(params[:group_id])
        flash[:success] = @group.name + "に予定行動時間を登録にしました。"
        redirect_to group_path(@group_plan.group_id)
      else
        flash[:danger] = "登録に失敗しました。もう一度、入力をお確かめの上ご登録お願いします。"
        redirect_to group_path(@group_plan.group_id)
      end
    else
      if pre_plan_data.update(groups_plans_params)
        @group = Group.find(params[:group_id])
        flash[:success] = @group.name + "のデータを更新しました。"
        redirect_to group_path(@group_plan.group_id)
      else
        flash[:danger] = "データの更新に失敗しました。"
        redirect_to group_path(@group_plan.group_id)
      end
    end
  end


  private

  def groups_plans_params
    params.require(:group_plan).permit(:day_of_week, :time_hour, :time_minute, :user_id)
  end
end
