class Post < ApplicationRecord
  validates :admin, presence: true
  validates :published_at, date: true
  validates :title, :content, presence: true
  validates :slug, uniqueness: { case_sensitive: false }, presence: true

  belongs_to :admin
  has_many :uploads, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :uploads
end
