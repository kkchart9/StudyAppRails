class WorksController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def index
    # クエリストリングがあればTimeオブジェクトに変換、ない場合は現在の時刻を取得
    @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    # 取得した時刻が含まれる月の範囲のデータを取得
    @works = Work.where(updated_at: @month.all_month)
  end

  def create
    @work = current_user.works.build(work_params)
    if @work.save
      flash[:info] = "登録しました。"
      redirect_to root_url
    else
      render root_url
    end
  end

  private

  def work_params
    params.require(:work).permit(:work_time)
  end
end
