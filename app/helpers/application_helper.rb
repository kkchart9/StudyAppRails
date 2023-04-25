module ApplicationHelper

  # 分数をテキストに変換
  def get_time_text(minute)
    hour_tx = (minute / 60).to_s
    minute_tx = (minute % 60).to_s

    if minute == 0
      return "-----"
    end

    if hour_tx.length == 1
      hour_tx = "0" + hour_tx
    end
    if minute_tx.length == 1
      minute_tx = "0" + minute_tx
    end
    time_tx = hour_tx + ':' + minute_tx
    return  time_tx
  end


end
