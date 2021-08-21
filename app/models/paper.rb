class Paper < ApplicationRecord
  extend FriendlyId
  friendly_id :reference_and_title, use: :scoped, scope: [:department]

  belongs_to :department

  # enable search
  searchkick language: 'german',
             text_start: [:title],
             word_start: [:title],
             highlight: [:title, :contents],
             searchable: [:contents],
             index_prefix: 'sehrgutachten'

  scope :search_import, -> { includes(:department) }

  def should_index?
    !downloaded_at.nil? && !contents.blank?
  end

  def search_data
    {
      title: title,
      contents: contents,
      department: department.short_name,
      created_at: created_at
    }
  end

  def autocomplete_data
    {
      title: title,
      reference: reference,
      source: department.short_name,
      url: Rails.application.routes.url_helpers.paper_path(department, self)
    }
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def reference_and_title
    [
      [:slug_reference, :title]
    ]
  end

  def slug_reference
    reference.gsub('/', '-')
  end

  def normalize_friendly_id(value)
    value.to_s.gsub('&', 'und').parameterize.truncate(120, separator: '-', omission: '')
  end

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
