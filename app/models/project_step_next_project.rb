class ProjectStepNextProject < ApplicationRecord
  audited

  belongs_to :project_step
end
