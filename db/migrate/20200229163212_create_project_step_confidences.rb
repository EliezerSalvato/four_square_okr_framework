class CreateProjectStepConfidences < ActiveRecord::Migration[6.0]
  def change
    create_table :project_step_confidences do |t|
      t.references :project_step, null: false, foreign_key: true, index: true
      t.string :confidence, null: false
      t.string :content, null: false

      t.timestamps
    end
  end
end
