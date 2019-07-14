# frozen_string_literal: true

class AddNicknameToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :nickname, :string
  end
end
