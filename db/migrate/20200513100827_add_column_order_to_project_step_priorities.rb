class AddColumnOrderToProjectStepPriorities < ActiveRecord::Migration[6.0]
  def change
    add_column :project_step_priorities, :order, :integer, default: 0
  end
end
