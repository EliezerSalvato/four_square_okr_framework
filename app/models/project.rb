class Project < ApplicationRecord
  audited

  has_many :project_steps, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
