class PlansController < ApplicationController
  before_action :logged_in_user

  def index
    @plan_post  = Plan.new
    @plans = get_plan_week(current_user.plans)

  end

  def create
    day_of_week = plan_params["plan_day_of_week"]
    pre_plan_data = current_user.plans.where(plan_day_of_week: day_of_week)

    if pre_plan_data.empty?
      @plan = current_user.plans.build(plan_params)
      if @plan.save
        flash[:info] = "登録しました。"
        redirect_to plans_path
      else
        flash[:danger] = "登録に失敗しました。"
        redirect_to plans_path
      end
    else
      if pre_plan_data.update(plan_params)
        flash[:info] = "データを更新しました。"
        redirect_to plans_path
      else
        flash[:danger] = "データの更新に失敗しました。"
        redirect_to plans_path
      end
    end
  end

  def edit
    redirect_to root_url
  end

  private

  def plan_params
    params.require(:plan).permit(:plan_time_hour, :plan_time_minute, :plan_day_of_week)
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
