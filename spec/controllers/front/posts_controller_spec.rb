require 'rails_helper'

describe Front::PostsController do
  before :each do
    @post = create(:post)
  end

  describe 'GET #show' do
    it 'render :show view' do
      get :show, slug: @post.slug

      expect(response).to render_template :show
    end

    it 'will assign :post variable' do
      get :show, slug: @post.slug

      expect(assigns(:post)).to eq @post
    end
  end

  describe 'GET #index' do
    it 'render :index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
