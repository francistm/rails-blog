require 'rails_helper'

describe Admin::PostsController do
  before :each do
    sign_in :admin, create(:admin)
  end

  describe 'GET #new' do
    it 'render :new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'render :edit view' do
      post = create(:post)
      get :edit, id: post.id

      expect(assigns(:post)).to eq post
      expect(response).to render_template :edit
    end
  end

  describe 'GET #index' do
    it 'render :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    it 'render :new view if failed (slug blank)' do
      post :create, post: attributes_for(:post, slug: '')

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :new
    end

    it 'render :new view if failed (slug duplicate)' do
      original_post = create(:post)
      post :create, post: attributes_for(:post, slug: original_post.slug)

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :new
    end

    it 'render :new view if failed (title blank)' do
      post :create, post: attributes_for(:post, title: '')

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :new
    end

    it 'render :new view if failed (content blank)' do
      post :create, post: attributes_for(:post, content: '')

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :new
    end

    it 'render :new view if failed (published_at blank)' do
      post :create, post: attributes_for(:post, published_at: '')

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :new
    end

    it 'redirect with flash if create post succeed' do
      post :create, post: attributes_for(:post)

      expect(flash[:success]).not_to be_blank
      expect(response).to redirect_to [:admin, :posts]
    end
  end

  describe 'PATCH #update' do
    before :each do
      @post = create(:post)
    end

    it 'render :edit view if failed (slug blank)' do
      patch :update, id: @post.id, post: attributes_for(:post, slug: '')

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :edit
    end

    it 'render :edit view if failed (slug duplicate)' do
      post = create(:post)
      patch :update, id: @post.id, post: attributes_for(:post, slug: post.slug)

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :edit
    end

    it 'render :edit view if failed (title blank)' do
      patch :update, id: @post.id, post: attributes_for(:post, title: '')

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :edit
    end

    it 'render :edit view if failed (content blank)' do
      patch :update, id: @post.id, post: attributes_for(:post, content: '')

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :edit
    end

    it 'render :edit view if failed (published_at blank)' do
      patch :update, id: @post.id, post: attributes_for(:post, published_at: '')

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :edit
    end

    it 'redirect with flash if update post succeed' do
      attrs = attributes_for(:post)
      patch :update, id: @post.id, post: attrs

      @post.reload

      expect(@post.slug).to eq attrs[:slug]
      expect(@post.title).to eq attrs[:title]
      expect(@post.content).to eq attrs[:content]

      expect(flash[:success]).not_to be_blank
      expect(response).to redirect_to [:admin, :posts]
    end
  end

  describe 'DELETE #destroy' do
    it 'redirect with flash if destroy succeed' do
      post = create(:post)

      p = Proc.new {
        delete :destroy, id: post.id
      }

      expect(p).to change(Post, :count).by -1
      expect(flash[:success]).not_to be_blank
      expect(response).to redirect_to [:admin, :posts]
    end
  end
end
