# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :slug
      t.string :title
      t.text :content
      t.integer :admin_id
      t.datetime :published_at

      t.timestamps null: false
    end

    add_index :posts, :admin_id
    add_index :posts, :slug, unique: true
  end
end
