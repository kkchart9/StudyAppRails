class WorksController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def index
    # クエリストリングがあればTimeオブジェクトに変換、ない場合は現在の時刻を取得
    @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    # 取得した時刻が含まれる月の範囲のデータを取得
    @works = Work.where(updated_at: @month.all_month)
  end

  def create
    @work = current_user.works.build(work_params)
    @plans = get_plan_week(current_user.plans)
    @day_works = get_total_day_work(current_user.works.where(work_date: @work[:work_date]))
    @day_of_week = @work[:work_date].wday
    work_time = (@work[:work_time_hour].to_i * 60) + @work[:work_time_minute].to_i
    content_tx = get_content_text(@work[:work_date], work_time, @plans, @day_of_week, @day_works)
    @microposts = current_user.microposts.build(content: content_tx)

    if @work[:work_time_hour] == 0 and @work[:work_time_minute] == 0
      flash[:info] = "登録に失敗しました。もう一度、入力をお確かめの上ご登録お願いします。"
      redirect_to root_url
    elsif @work.save and @microposts.save
      flash[:info] = "登録しました。"
      redirect_to root_url
    else
      flash[:danger] = "登録に失敗しました。もう一度、入力をお確かめの上ご登録お願いします。"
      redirect_to root_url
    end
  end

  def destroy
    @work.destroy
    flash[:success] = '削除しました。'
    redirect_to request.referrer || root_url
  end

  private

  def work_params
    params.require(:work).permit(:work_time_hour, :work_time_minute, :work_date)
  end

  def micropost_params
    params.require(:work).permit(:content)
  end

  # 分数をテキストに変換
  def get_time_text(hour, minute)
    hour = hour.to_s
    minute = minute.to_s

    if minute.length == 1
      minute_tx = "0" + minute
    end
    time_tx = hour.to_s + '時間' + minute_tx.to_s + '分'
    return  time_tx
  end

  # 分数を時間分のテキストに変換
  def get_time_ja_text(minute)
    hour_tx = (minute/60).to_s
    minute_tx = (minute%60).to_s
    if minute_tx.length == 1
      minute_tx = "0" + minute_tx
    end
    time_tx = hour_tx + "時間" + minute_tx + "分"
    return time_tx
  end

  def get_content_plans_work(plans, day_of_week)
    if plans[day_of_week]
      return plans[day_of_week]
    else
      return 0
    end
  end

  def get_content_text(date, time, plans, day_of_week, day_works)
    plan_time = get_content_plans_work(plans, day_of_week)
    day_works += time
    if plan_time == 0
      text = date.year.to_s + '/' + date.month.to_s + "/" + date.day.to_s + "に、" + get_time_ja_text(time) + "行動しました。\n本日の行動予定は" + get_time_ja_text(plan_time) + "です。\n"
    else
      plan_per = day_works.to_f/plan_time * 100
      plan_per = sprintf("%.f", plan_per)
      text = date.year.to_s + '/' + date.month.to_s + "/" + date.day.to_s + "に、" + get_time_ja_text(time) + "行動しました。\n本日の行動予定は" + get_time_ja_text(plan_time) + "です。\n" + plan_per + "％の達成度です。"
    end

    return text
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


  def get_total_day_work(works)
    total_time = 0
    works.each do |work|
      hour = work[:work_time_hour].to_i
      minute = work[:work_time_minute].to_i
      time = hour*60 + minute
      total_time += time
    end

    return total_time
  end

  def correct_user
    @work = current_user.works.find_by(id: params[:id])
    redirect_to root_url if @work.nil?
  end
end
