# frozen_string_literal: true

class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.integer :attachable_id
      t.string :attachable_type
      t.integer :admin_id

      t.timestamps null: false
    end

    add_index :uploads, :attachable_id
  end
end
