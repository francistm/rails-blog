# frozen_string_literal: true

class Link < ApplicationRecord
  validates :url, :title, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, if: proc { |link| link.url.present? }
end
