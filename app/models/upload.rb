# frozen_string_literal: true

class Upload < ApplicationRecord
  attr_accessor :file

  validates :admin, presence: true
  # validates :file, attachment_presence: true
  # validates :file, attachment_content_type: { content_type: /\Aimage\/.*\z/ }

  # has_attached_file :file, path: ':class/:attachment/:id/:basename.:extension'

  belongs_to :admin
  belongs_to :attachable, polymorphic: true

  def is_image?
    file_content_type =~ %r{\Aimage/.*\z}
  end
end
