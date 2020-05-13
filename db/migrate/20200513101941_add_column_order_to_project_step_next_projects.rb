class AddColumnOrderToProjectStepNextProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :project_step_next_projects, :order, :integer, default: 0
  end
end
