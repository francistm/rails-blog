# frozen_string_literal: true

class AddAttachmentFileToUploads < ActiveRecord::Migration
  def self.up
    change_table :uploads do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :uploads, :file
  end
end
