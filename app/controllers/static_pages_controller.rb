class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @work = Work.new


      @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
      @works = current_user.works.where(work_time: @month.all_month)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
