class AddUserIdToGroupPlans < ActiveRecord::Migration[5.0]
  def change
    add_reference :group_plans, :user, foreign_keys: true
  end
end
