# frozen_string_literal: true

# RailsSettings Model
class SiteSetting < RailsSettings::Base
  source Rails.root.join('config/application.yml')

  # When config/app.yml has changed, you need change this prefix to v2, v3 ... to expires caches
  # cache_prefix { "v1" }
end
