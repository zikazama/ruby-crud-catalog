class Product < ApplicationRecord
  belongs_to :category, optional: true
  validates :name, presence: true

  # Manual status handling for publish
  scope :published, -> { where(publish: 1) }
  scope :unpublished, -> { where(publish: 0) }

  def published?
    publish == 1
  end

  def unpublished?
    publish == 0
  end

  def publish
    self[:publish]
  end

  def publish=(value)
    self[:publish] = value
  end

  def publish_status
    publish == 1 ? 'yes' : 'no'
  end

  def publish_status=(value)
    self.publish = (value.to_s == 'yes' ? 1 : 0)
  end
end
