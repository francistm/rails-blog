class Link < ApplicationRecord
  validates :url, :title, presence: true
  validates :url, format: { with: URI.regexp }, if: Proc.new { |link| link.url.present? }
end
