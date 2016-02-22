class Paper < ApplicationRecord
  belongs_to :department

  def created_at
    self[:created_at].to_date
  end

end
