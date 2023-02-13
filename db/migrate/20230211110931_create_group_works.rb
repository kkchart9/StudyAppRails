class CreateGroupWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :group_works do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.date :date
      t.integer :time_hour
      t.integer :time_minute
      t.timestamps
    end
  end
end
