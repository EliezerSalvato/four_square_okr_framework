class ProjectStepPriority < ApplicationRecord
  audited

  belongs_to :project_step
end
