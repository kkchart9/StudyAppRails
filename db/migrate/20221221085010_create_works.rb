class CreateWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :works do |t|
      t.datetime :work_time
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
