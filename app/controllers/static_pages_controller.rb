class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @work = Work.new
      # 今日の日付を取得
      @today = Date.today
      # current_userの今日のデータを取得
      @today_works = current_user.works.where(work_date: @today)

      @month = params[:month] ? Date.parse(params[:month]) : Date.today
      @month_works = current_user.works.where(work_date: @month.all_month)

      @works_list = get_works_list(@month_works)
      @total_month_time = get_total_month_time(@month_works)
      @total_day_works = get_total_day_works(@works_list)
      @plans = get_plan_week(current_user.plans)
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  private

  def get_works_list(month_works)
    works_list = {}
    month_works.each do |work|
      work_time = (work.work_time_hour.to_i*60) + work.work_time_minute.to_i

      if works_list[work.work_date.day]
        works_list[work.work_date.day].push([work[:id], work_time])
      else
        works_list[work.work_date.day] = [[work[:id], work_time]]
      end
    end
    return works_list
  end

  # 月の総勉強時間を取得
  def get_total_month_time(month_works)
    hour = 0
    minute = 0
    month_works.each do |works_time|
      hour += works_time[:work_time_hour]
      minute += works_time[:work_time_minute]
      if minute >= 60
        minute -= 60
        hour += 1
      end
    end
    total_month_time = hour*60 + minute

    return total_month_time
  end

  # 月の中で一番頑張った日を取得
  def get_worked_hard(month_works)
    worked_hard_day = 0
    worked_hard_time = 0
    month_works.each do |works_time|
      time = works_time[:work_time_hour] * 60 + works_time[:work_time_minute]
      if worked_hard_time <= time
        worked_hard_time = time
        worked_hard_day = works_time[:work_date]
      end
    end

    return worked_hard_day, worked_hard_time
  end

  def get_total_day_works(works_list)
    total_works_list = {}
    works_list.each do |work_times|
      key = work_times[0]
      val = work_times[1]
      minute = 0
      val.each do |time|
        minute += time[1].to_i
      end
      total_works_list[key] = minute
    end

    return total_works_list
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
