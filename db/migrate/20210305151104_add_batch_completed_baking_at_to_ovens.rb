class AddBatchCompletedBakingAtToOvens < ActiveRecord::Migration[5.1]
  def change
    add_column :ovens, :batch_completed_baking_at, :datetime
  end
end
