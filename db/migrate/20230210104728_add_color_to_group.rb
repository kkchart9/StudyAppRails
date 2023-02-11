class AddColorToGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :color, :string
  end
end
