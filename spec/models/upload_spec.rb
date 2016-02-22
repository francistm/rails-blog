require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe Upload, type: :model do
  it 'will be valid' do
    expect(build :upload_with_image).to be_valid
  end

  it 'will invalid if file nil' do
    expect(build :upload, file: nil).to be_invalid
  end

  it 'will invalid if admin_id nil' do
    expect(build :upload_with_image, admin_id: nil).to be_invalid
  end

  it 'image file will get true when invoke #is_image?' do
    expect(build(:upload_with_image).is_image?).to be_truthy
  end

  it 'will invalid if file Content-Type isn\'t image' do
    expect(build :upload_with_non_image).to be_invalid
  end
end
