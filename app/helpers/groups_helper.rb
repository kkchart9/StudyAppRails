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


end
