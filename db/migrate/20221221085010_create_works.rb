class CreateWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :works do |t|
      t.date :work_date
      t.integer :work_time_hour
      t.integer :work_time_minute
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
