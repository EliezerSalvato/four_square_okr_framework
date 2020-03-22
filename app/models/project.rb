class Project < ApplicationRecord
  has_many :project_steps, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
