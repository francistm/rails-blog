# frozen_string_literal: true

class Post < ApplicationRecord
  validates :admin, presence: true
  validates :published_at, date: true
  validates :title, :content, presence: true
  validates :slug, uniqueness: { case_sensitive: false }, presence: true

  belongs_to :admin
  has_many_attached :uploads
end
