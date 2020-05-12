class AddColumnObjectiveToProjectSteps < ActiveRecord::Migration[6.0]
  def change
    add_column :project_steps, :objective, :text
  end
end
