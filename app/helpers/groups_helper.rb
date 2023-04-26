module GroupsHelper


  # グループメンバーごとの行動時間を日付ごとにリスト化する
  # {date => [ group_work_id, user_id, work_time ]}
  def get_member_work(month_works)
    member_work_list = {}
    
    month_works.each do |work|
      work_time = (work.time_hour.to_i*60) + work.time_minute.to_i

      if member_work_list[work.date.day]
        member_work_list[work.date.day].push([work[:id], work[:user_id], work_time])
      else
        member_work_list[work.date.day] = [[work[:id], work[:user_id], work_time]]
      end
    end

    return member_work_list

  end


  # グループ詳細画面にて、２次元配列のデータを作成する
  # {['日', 14(%)], ['月', 14(%)], ['火', 14(%)], ['水', 0(%)], ['木', 14(%)], ['金', 100(%)], ['土', 0(%)]] }
  def create_chart(user_work_data, user_plan_data)
    data = [['日'], ['月'], ['火'], ['水'], ['木'], ['金'], ['土']]
    7.times do |time|
      day_of_week_per = 0
      if user_plan_data[time].nil? or user_plan_data[time] == 0
        data[time].push(day_of_week_per)
      else
        month_total_plan_time = @wday_count[time] * user_plan_data[time]
        total_work_time = user_work_data[time]
        if !total_work_time.nil?
          day_of_week_per_tmp = total_work_time.to_f / month_total_plan_time * 100
          day_of_week_per = sprintf("%.f", day_of_week_per_tmp)
        end
        data[time].push(day_of_week_per)
      end
    end
    return data
  end

end
