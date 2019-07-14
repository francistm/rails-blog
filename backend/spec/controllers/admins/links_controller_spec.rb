require 'faker'
require 'rails_helper'

describe Admins::LinksController do
  before :each do
    sign_in create(:admin), scope: :admin
  end

  describe 'GET #new' do
    it 'render :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before :each do
      @link = create :link
    end

    it 'render :edit template' do
      get :edit, params: {id: @link.id}
      expect(response).to render_template :edit
    end

    it 'assigns :link variable' do
      get :edit, params: {id: @link.id}
      expect(assigns(:link)).to eq @link
    end
  end

  describe 'GET #index' do
    it 'render :index template' do
      create_list :link, 10
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    it 'redirect if create success' do
      post :create, params: {link: attributes_for(:link)}

      expect(flash[:success]).not_to be_blank
      expect(response).to redirect_to [:admins, :links]
    end

    it 'render :new if url blank' do
      post :create, params: {link: attributes_for(:link, url: '')}

      expect(flash.now[:danger]).not_to be_blank
      expect(response).to render_template :new
    end

    it 'render :new if url invalid' do
      post :create, params: {
          link: attributes_for(:link, url: Faker::Name.name)
      }

      expect(flash.now[:danger]).not_to be_blank
      expect(response).to render_template :new
    end

    it 'render :new if title blank' do
      post :create, params: {
          link: attributes_for(:link, title: '')
      }

      expect(flash.now[:danger]).not_to be_blank
      expect(response).to render_template :new
    end
  end

  describe 'PATCH #update' do
    before :each do
      @link = create(:link)
    end

    it 'redirect if update success' do
      patch :update, params: {
          id: @link.id, link: attributes_for(:link)
      }

      expect(flash[:success]).not_to be_blank
      expect(response).to redirect_to [:admins, :links]
    end

    it 'render :edit if url blank' do
      patch :update, params: {
          id: @link.id, link: attributes_for(:link, url: '')
      }

      expect(flash.now[:danger]).not_to be_blank
      expect(response).to render_template :edit
    end

    it 'render :new if url invalid' do
      patch :update, params: {
          id: @link.id, link: attributes_for(:link, url: Faker::Name.name)
      }

      expect(flash.now[:danger]).not_to be_blank
      expect(response).to render_template :edit
    end

    it 'render :new if title blank' do
      patch :update, params: {
          id: @link.id, link: attributes_for(:link, title: '')
      }

      expect(flash.now[:danger]).not_to be_blank
      expect(response).to render_template :edit
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @link = create(:link)
    end

    it 'redirect after request' do
      delete :destroy, params: {id: @link.id}
      expect(response).to redirect_to [:admins, :links]
    end

    it 'change db when destroy success' do
      p = Proc.new { delete :destroy, params: {id: @link.id} }
      expect(p).to change(Link, :count).by -1
    end
  end
end
