require 'faker'
require 'rails_helper'

describe "Post form", type: :system do
  before :each do
    login_as create(:admin), scope: :admin
  end

  after :each do
    Warden.test_reset!
  end

  it 'submit without upload file' do
    visit new_admins_post_url

    post_slug = Faker::Internet.slug
    post_title = Faker::Lorem.sentence

    assert_selector "h1", text: "添加新日志"

    fill_in 'Slug', with: post_slug
    fill_in '标题', with: post_title
    fill_in '正文', with: Faker::Markdown.random

    click_button '新增日志'

    expect(page).to have_text(post_slug)
    expect(page).to have_text(post_title)
  end

  it 'submit with upload file' do
    visit new_admins_post_url

    post_slug = Faker::Internet.slug
    post_title = Faker::Lorem.sentence
    post_attach_files = [].tap do |array|
      array << File.expand_path("../../../fixtures/files/file-image-fixture-1.jpg", __FILE__)
      array << File.expand_path("../../../fixtures/files/file-image-fixture-2.jpg", __FILE__)
      array << File.expand_path("../../../fixtures/files/file-image-fixture-3.jpg", __FILE__)
    end

    assert_selector "h1", text: "添加新日志"

    fill_in 'Slug', with: post_slug
    fill_in '标题', with: post_title
    page.find('input#post_uploads.file-hidden-input', visible: :hidden).attach_file post_attach_files
    fill_in '正文', with: Faker::Markdown.random

    expect(page).to have_text("file-image-fixture-1.jpg")
    expect(page).to have_text("file-image-fixture-2.jpg")
    expect(page).to have_text("file-image-fixture-3.jpg")

    click_button '新增日志'

    expect(page).to have_text(post_slug)
    expect(page).to have_text(post_title)
  end

  it 'delete upload before submit' do
    visit new_admins_post_url

    post_attach_files = [].tap do |array|
      array << File.expand_path("../../../fixtures/files/file-image-fixture-1.jpg", __FILE__)
      array << File.expand_path("../../../fixtures/files/file-image-fixture-2.jpg", __FILE__)
      array << File.expand_path("../../../fixtures/files/file-image-fixture-3.jpg", __FILE__)
    end

    assert_selector "h1", text: "添加新日志"

    page.find('input#post_uploads.file-hidden-input', visible: :hidden).attach_file post_attach_files

    page.find('table#uploads-table').find('tbody').first('tr').find('button.btn-danger').click
    page.find('table#uploads-table').find('tbody').first('tr').find('button.btn-danger').click
    page.find('table#uploads-table').find('tbody').first('tr').find('button.btn-danger').click

    expect(page).not_to have_text("file-image-fixture-1.jpg")
    expect(page).not_to have_text("file-image-fixture-2.jpg")
    expect(page).not_to have_text("file-image-fixture-3.jpg")
  end
end
