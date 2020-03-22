class CreateProjectStepPriorities < ActiveRecord::Migration[6.0]
  def change
    create_table :project_step_priorities do |t|
      t.references :project_step, null: false, foreign_key: true, index: true
      t.string :priority, null: false
      t.string :content, null: false
      t.text :annotation

      t.timestamps
    end
  end
end
