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
end
