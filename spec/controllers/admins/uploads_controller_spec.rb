require 'rails_helper'

describe Admins::UploadsController do
  before :all do
    skip if ENV["SKIP_QINIU_UPLOAD"] == "true"
  end

  before :each do
    sign_in create(:admin), scope: :admin
  end

  describe 'GET #new' do
    it 'render :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    after :each do
      @upload.destroy
    end

    before :each do
      @upload = create(:upload_with_image)
    end

    it 'render :show template' do
      get :show, id: @upload.id
      expect(response).to render_template :show
    end

    it 'assign :upload instance' do
      get :show, id: @upload.id
      expect(assigns(:upload)).to eq @upload
    end
  end

  describe 'GET #index' do
    after :each do
      @uploads.each { |upload| upload.destroy }
    end

    before :each do
      @uploads = create_list :upload_with_image, 5
    end

    it 'render :index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    it 'render :new if create failed by html' do
      post :create, upload: attributes_for(:upload_with_non_image)
      expect(response).to render_template :new
      expect(flash.now[:danger]).not_to be_blank
    end

    it 'render js template if succeed by js' do
      post :create, params: {upload: attributes_for(:upload_with_image)}, format: :js
      expect(response).to render_template :create
      assigns(:upload).destroy
    end

    it 'redirect to admin/uploads#index if succeed by html' do
      post :create, params: {upload: attributes_for(:upload_with_image)}
      expect(response).to redirect_to [:admins, :uploads]
      assigns(:upload).destroy
    end
  end

  describe 'DELETE #destroy' do
    it 'reduct uploads count' do
      upload = create(:upload_with_image)
      p = Proc.new { delete :destroy, id: upload.id }
      expect(p).to change(Upload, :count).by -1
    end

    it 'redirect to admin/uploads#index' do
      upload = create(:upload_with_image)
      delete :destroy, id: upload.id
      expect(response).to redirect_to [:admins, :uploads]
    end
  end
end
