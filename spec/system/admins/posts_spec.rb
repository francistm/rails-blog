require 'faker'
require 'rails_helper'

describe "Create Post", type: :system do
  before :each do
    login_as create(:admin), scope: :admin
  end

  after :each do
    Warden.test_reset!
  end

  before :all do
    driven_by :selenium, using: :firefox
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

    post_attach_file = File.expand_path("../../../fixtures/files/file-image-fixture.jpg", __FILE__)

    assert_selector "h1", text: "添加新日志"

    page.find('input#post_uploads.file-hidden-input', visible: :hidden).attach_file post_attach_file

    expect(page).to have_text("file-image-fixture.jpg")
  end

  it 'delete file after upload before submit' do
    visit new_admins_post_url

    post_attach_file = File.expand_path("../../../fixtures/files/file-image-fixture.jpg", __FILE__)

    assert_selector "h1", text: "添加新日志"

    page.find('input#post_uploads.file-hidden-input', visible: :hidden).attach_file post_attach_file
    page.find('table#uploads-table').find('tbody').first('tr').find('button.btn-danger').click

    expect(page).not_to have_text("file-image-fixture.jpg")
  end
end
