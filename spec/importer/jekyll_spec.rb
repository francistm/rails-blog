require 'faker'
require 'rails_helper'
require Rails.root.join('app', 'importer', 'jekyll')

describe 'Importer::Jekyll' do
  before :each do
    @jekyll_post_path = File.expand_path(File.dirname(__FILE__)) +
        '/../fixtures/files/2012-06-29-jekyll_post.md'
  end

  it 'not valid if pass invalid content' do
    content = Faker::Lorem.paragraph
    jekyll_filename = File.basename @jekyll_post_path
    importer = Importer::Jekyll.new(
        filename: jekyll_filename,
        content: content
    )

    expect(importer).to be_invalid
  end

  it 'get new jekyll instance when pass valid content' do
    jekyll_file = File.open(@jekyll_post_path, 'r')
    jekyll_filename = File.basename @jekyll_post_path
    jekyll_importer = Importer::Jekyll.new(
        filename: jekyll_filename,
        content: jekyll_file.read
    )

    expect(jekyll_importer).to be_valid
  end

  it 'get correct jekyll post title' do
    jekyll_file = File.open(@jekyll_post_path, 'r')
    jekyll_filename = File.basename @jekyll_post_path
    jekyll_importer = Importer::Jekyll.new(
        filename: jekyll_filename,
        content: jekyll_file.read
    )

    expect(jekyll_importer.attributes[:title]).to eq 'Test Jekyll Post'
  end

  it 'get correct jekyll post content' do
    post_content = '
This is a test jekyll post

This file is using Markdown format

- Item in list
- Another item in list
    '

    jekyll_file = File.open(@jekyll_post_path, 'r')
    jekyll_filename = File.basename @jekyll_post_path
    jekyll_importer = Importer::Jekyll.new(
        filename: jekyll_filename,
        content: jekyll_file.read
    )

    expect(jekyll_importer.attributes[:content]).to eq post_content.strip
  end
end
