class AddColumnOrderToProjectStepHealthMetrics < ActiveRecord::Migration[6.0]
  def change
    add_column :project_step_health_metrics, :order, :integer, default: 0
  end
end
