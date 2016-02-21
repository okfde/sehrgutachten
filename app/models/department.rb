class Department < ApplicationRecord
  extend FriendlyId
  friendly_id :short_name, use: :slugged
  
  has_many :papers
end
