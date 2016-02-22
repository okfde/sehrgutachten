class Paper < ApplicationRecord
  belongs_to :department

  def created_at
    self[:created_at].to_date
  end

  def path
    File.join(department.short_name, reference.gsub('/', '_').to_s + '.pdf')
  end

  def local_path
    Rails.configuration.x.paper_storage.join(path)
  end

end
