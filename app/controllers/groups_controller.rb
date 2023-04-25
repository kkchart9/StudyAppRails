class GroupsController < ApplicationController
  before_action :logged_in_user, only: [:index, :create, :show, :add, :remove, :destroy]
  # before_action :correct_user, only: :destroy

  def index
    @groups = get_group_name(current_user.groups)
    @group = Group.new
  end

  def create
    @group = current_user.groups.create(group_params.merge(create_user_id: current_user.id))
    if @group.save
      flash[:success] = "作成しました。"
      redirect_to groups_path
    else
      flash[:danger] = "登録に失敗しました。もう一度、入力をお確かめの上ご登録お願いします。"
      redirect_to groups_path
    end
  end

  def show
    member_list = Member.where(group_id: params[:id]).pluck(:user_id)
    @group = Group.find(params[:id])
    @members = @group.users
    @member = Member.new
    @month = params[:month] ? Date.parse(params[:month]) : Date.today
    @month_works = GroupWork.where(date: @month.all_month, group_id: @group.id, user_id: member_list)
    @works_list = get_works_list(@month_works)
    @total_day_works = get_total_day_works(@works_list)
    @plans = get_plan_week(GroupPlan.where(group_id: params[:id]))

    @member_total_plans = get_member_total_plan(GroupPlan.where(group_id: params[:id], user_id: member_list))
    @member_plans = get_member_plan(params[:id], member_list)


    @group_work = GroupWork.new
    @group_plan = GroupPlan.new
  end


  def add
    @group = Group.find(params[:id])
    @add_user = User.find_by(email: params[:email])
    if @add_user
      flash[:success] = @add_user.name + "を"+ @group.name + "に追加しました。"
      @add_user.groups << @group
    else
      flash[:info] = "ユーザーが見つかりませんでした。入力を確認の上、もう一度お試しください。"
    end
    redirect_to group_path(@group)
  end

  def remove
    @members = Member.where(group_id: params[:id])
    @member = @members.find_by(user_id: params[:user_id])
    @user = User.find(params[:user_id])
    @group = Group.find(params[:id])
    flash[:success] = @user.name + "を" + @group.name +  "から削除しました。"
    @member.destroy
    redirect_to groups_path
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:success] = '削除しました。'
    redirect_to groups_path
  end


  private

  def group_params
    params.require(:group).permit(:name)
  end

  def get_group_name(members)
    admin_groups = []
    not_admin_groups = []
    members.each do |member|
      if member[:create_user_id] == current_user.id
        admin_groups << member
      else
        not_admin_groups << member
      end
    end
    return admin_groups, not_admin_groups
  end

  # 日付に対する行動時間
  # { date => [ :id, work_time{合計時間}, :user_id ]}
  def get_works_list(month_works)
    works_list = {}
    month_works.each do |work|
      work_time = (work.time_hour.to_i*60) + work.time_minute.to_i
      # work_time = work.work_time_hour.to_s + ":" + work.work_time_minute.to_s

      if works_list[work.date.day]
        works_list[work.date.day].push([work[:id], work_time, work[:user_id]])
      else
        works_list[work.date.day] = [[work[:id], work_time, work[:user_id]]]
      end
    end
    return works_list
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
      key = plan[:day_of_week]
      val = (plan[:time_hour]*60) + plan[:time_minute]
      plan_week[key] = val
    end

    return plan_week
  end

  # グループメンバーごとの行動予定時間を曜日ごとにリスト化する
  # { user_id => { day_of_week => time } }
  def get_member_plan(group_id, members)
    group_plans = GroupPlan.where(group_id: group_id).where(user_id: members)
    members_plan = {}

    members.each do |member|
      member_plans = group_plans.where(user_id: member)
      if member_plans.empty?
        members_plan[member] = {}
      else
        plans = {}
        member_plans.each do |plan|
          time = plan[:time_hour] * 60 + plan[:time_minute]
          plans[plan[:day_of_week]] = time
        end
        members_plan[member] = plans
      end
    end

    return members_plan
  end

  def get_member_total_plan(month_works)

    member_total_plan = {}
    month_works.each do |plan|
      key = plan[:day_of_week]
      val = (plan[:time_hour]*60) + plan[:time_minute]

      if member_total_plan[key]
        member_total_plan[key] += val
      else
        member_total_plan[key] = val
      end
    end

    return member_total_plan
  end
end
