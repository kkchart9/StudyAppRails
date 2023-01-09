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
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
