require 'rails_helper'

describe Admins::JekyllImportsController do
  before :each do
    sign_in :admin, create(:admin)
  end

  describe 'GET #new' do
    it 'render :new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    it 'redirect if jekyll import succeed' do
      p = Proc.new {
        post :create, jekyll_import: {
          post: fixture_file_upload('files/2012-06-29-jekyll_post.md', 'text/plain')
        }
      }

      expect(p).to change(Post, :count).by 1
      expect(flash[:success]).not_to be_blank
      expect(response).to redirect_to [:admins, :posts]
    end

    it 'render :new view if import file invalid' do
      post :create, jekyll_import: {
        post: fixture_file_upload('files/2012-06-29-jekyll_post_invalid.md', 'text/plain')
      }

      expect(response).to render_template :new
      expect(flash.now[:danger]).not_to be_blank
    end

    it 'render :new view if no import file uploaded' do
      post :create, jekyll_import: { post: nil }

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :new
    end
  end
end
