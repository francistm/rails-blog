class Post < ActiveRecord::Base
  validates :admin, presence: true
  validates :published_at, date: true
  validates :title, :content, presence: true
  validates :slug, uniqueness: { case_sensitive: false }, presence: true

  belongs_to :admin
  has_many :uploads, as: :attachable
end
