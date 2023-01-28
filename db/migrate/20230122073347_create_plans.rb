class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.integer :plan_day_of_week
      t.integer :plan_time_hour
      t.integer :plan_time_minute
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
