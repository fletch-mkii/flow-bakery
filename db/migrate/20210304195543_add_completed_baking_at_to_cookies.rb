class AddCompletedBakingAtToCookies < ActiveRecord::Migration[5.1]
  def change
    add_column :cookies, :completed_baking_at, :datetime
  end
end
