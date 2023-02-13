class CreateGroupPlans < ActiveRecord::Migration[5.0]
  def change
    create_table :group_plans do |t|
      t.references :group, foreign_key: true
      t.integer :day_of_week
      t.integer :time_hour
      t.integer :time_minute
      t.timestamps
    end
  end
end
