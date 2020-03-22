class CreateProjectSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :project_steps do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :year
      t.string :quarter
      t.date :start_at
      t.date :end_at

      t.timestamps
    end
  end
end
