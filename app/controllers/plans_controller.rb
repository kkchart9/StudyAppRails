class PlansController < ApplicationController
  before_action :logged_in_user

  def index
    @plan_post  = Plan.new
    @plans = get_plan_week(current_user.plans)

  end

  def create
    day_of_week = plan_params["plan_day_of_week"]
    pre_plan_data = current_user.plans.find_by(plan_day_of_week: day_of_week)
    content_plan = get_content_plan_text(pre_plan_data, plan_params)
    @microposts = current_user.microposts.build(content: content_plan)


    if pre_plan_data.nil?
      @plan = current_user.plans.build(plan_params)
      if @plan.save and @microposts.save
        flash[:success] = "登録しました。"
        redirect_to plans_path
      else
        flash[:danger] = "登録に失敗しました。"
        redirect_to plans_path
      end
    else
      if pre_plan_data.update(plan_params) and @microposts.save
        flash[:success] = "データを更新しました。"
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

  def get_time_text(hour, minute)
    hour = hour.to_s
    minute = minute.to_s

    if minute.length == 1
      minute_tx = "0" + minute
    end
    time_tx = hour.to_s + '時間' + minute_tx.to_s + '分'
    return  time_tx
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


  def get_content_plan_text(pre_plan_data, plan_data)
    youbi = ['日', '月', '火', '水', '木', '金', '土']

    if pre_plan_data.nil?
      time = get_time_text(plan_data[:plan_time_hour], plan_data[:plan_time_minute])
      text = youbi[plan_data[:plan_day_of_week].to_i] + "曜日の行動予定時間を" + time+  "に新規登録しました。"
    else
      pre_time = get_time_text(pre_plan_data[:plan_time_hour], pre_plan_data[:plan_time_minute])
      time = get_time_text(plan_data[:plan_time_hour], plan_data[:plan_time_minute])

      if pre_plan_data[:plan_time_hour] == 0 and pre_plan_data[:plan_time_minute] == 0
        text = youbi[plan_data[:plan_day_of_week].to_i] + "曜日の行動予定時間を" + time+  "に新規登録しました。"
      else
        text = youbi[plan_data[:plan_day_of_week].to_i] + "曜日の行動予定時間を" + pre_time + "から"+ time + "に変更しました。"
      end
    end

    return text
  end
end
