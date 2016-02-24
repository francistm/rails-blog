require 'rails_helper'

describe Guests::SiteController do
  describe 'GET #feed' do
    it 'render xml format' do
      get :feed, format: :xml
      expect(response.content_type).to eq 'application/xml'
    end

    it 'render :feed xml builder' do
      get :feed, format: :xml
      expect(response).to render_template :feed
    end
  end

  describe 'GET #index' do
    it 'render :index template' do
      get :index
      expect(response).to render_template :index
    end
  end
end
