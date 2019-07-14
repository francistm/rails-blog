# frozen_string_literal: true

class ChangePublishedAtToDateInPosts < ActiveRecord::Migration
  def up
    change_table :posts do |t|
      t.change :published_at, :date
    end
  end

  def down
    change_table :posts do |t|
      t.change :published_at, :datetime
    end
  end
end
