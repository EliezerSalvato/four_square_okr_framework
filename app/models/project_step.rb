class ProjectStep < ApplicationRecord
  belongs_to :project
  has_many :priorities, class_name: 'ProjectStepPriority', dependent: :destroy
  has_many :confidences, class_name: 'ProjectStepConfidence', dependent: :destroy
  has_many :next_projects, class_name: 'ProjectStepNextProject', dependent: :destroy
  has_many :health_metrics, class_name: 'ProjectStepHealthMetric', dependent: :destroy

  accepts_nested_attributes_for :priorities
  accepts_nested_attributes_for :confidences
  accepts_nested_attributes_for :next_projects
  accepts_nested_attributes_for :health_metrics

  validate :uniqueness_of_dates
  validate :start_at_must_be_less_than_end_at

  private

  def uniqueness_of_dates
    project_step = ProjectStep.find_by(
      slice(:project_id, :year, :quarter, :start_at)
    )

    return if project_step.blank? || project_step.id == id

    errors.add(:base, 'There is already a step in this period.')
  end

  def start_at_must_be_less_than_end_at
    return if start_at < end_at

    errors.add(:base, 'Start at must be less than end at.')
  end
end
