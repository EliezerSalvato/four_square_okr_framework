class AddColumnOrderToProjectStepConfidences < ActiveRecord::Migration[6.0]
  def change
    add_column :project_step_confidences, :order, :integer, default: 0
  end
end
