class User < ApplicationRecord
  audited

  devise :database_authenticatable, :registerable, :validatable
end
