class CreateProjectStepHealthMetrics < ActiveRecord::Migration[6.0]
  def change
    create_table :project_step_health_metrics do |t|
      t.references :project_step, null: false, foreign_key: true, index: true
      t.string :health, null: false
      t.string :content, null: false

      t.timestamps
    end
  end
end
