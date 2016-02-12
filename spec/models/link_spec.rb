require 'rails_helper'

RSpec.describe Link, type: :model do
  it 'valid with url, title' do
    expect(build :link).to be_valid
  end

  it 'invalid without url' do
    expect(build :link, url: nil).to be_invalid
  end

  it 'invalid without title' do
    expect(build :link, title: nil).to be_invalid
  end

  it 'invalid with a non-url' do
    expect(build :link, url: 'foo foo').to be_invalid
  end
end
