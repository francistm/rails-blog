# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, type: :model do
  before :each do
    @password = '12345678'
    @admin = build(
      :admin,
      password: @password,
      password_confirmation: @password
    )
  end

  it 'valid with email, nickname' do
    expect(@admin).to be_valid
  end

  it 'invalid without email' do
    @admin.email = nil
    expect(@admin).to be_invalid
  end

  it 'invalid if email duplicate' do
    admin1 = create(:admin, password: @password, password_confirmation: @password)
    admin2 = build(:admin, email: admin1.email, password: @password, password_confirmation: @password)

    expect(admin2).to be_invalid
  end

  it 'invalid without nickname' do
    @admin.nickname = nil
    expect(@admin).to be_invalid
  end

  it 'invalid with password short than 8 chars' do
    @admin.password = '123456'
    expect(@admin).to be_invalid
  end

  it 'invalid if confirmation password not matched' do
    @admin.password_confirmation = 'abcdefghi'
    expect(@admin).to be_invalid
  end
end
