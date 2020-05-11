class ProjectStepConfidence < ApplicationRecord
  audited

  belongs_to :project_step
end
