require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'valid when has slug, title, content, admin_id' do
    expect(build :post).to be_valid
  end

  it 'invalid without slug' do
    expect(build :post, slug: nil).to be_invalid
  end

  it 'invalid if slug duplicate' do
    post1 = create(:post)
    post2 = build(:post, slug: post1.slug)

    expect(post2).to be_invalid
  end

  it 'invalid without title' do
    expect(build :post, title: nil).to be_invalid
  end

  it 'invalid without content' do
    expect(build :post, content: nil).to be_invalid
  end

  it 'invalid without admin_id' do
    expect(build :post, admin: nil).to be_invalid
  end

  it 'invalid if association admin not exists' do
    expect(build :post, admin_id: 0).to be_invalid
  end
end
