# frozen_string_literal: true

class AddDescriptionToLinks < ActiveRecord::Migration
  def change
    add_column :links, :description, :text
  end
end
