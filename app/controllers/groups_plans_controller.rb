class GroupsPlansController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    day_of_week = groups_plans_params[:day_of_week]
    user_id = current_user[:id]
    group_id = params[:group_id]
    @group_plan = GroupPlan.new(groups_plans_params.merge(group_id: params[:group_id], user_id: current_user[:id]))
    pre_plan_data = GroupPlan.where(group_id: params[:group_id], user_id: user_id).find_by(day_of_week: day_of_week)


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
    params.require(:group_plan).permit(:day_of_week, :time_hour, :time_minute)
  end
end
