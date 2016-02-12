require 'rails_helper'

describe Front::SiteController do
  describe 'GET #index' do
    it 'render :index template' do
      get :index
      expect(response).to render_template :index
    end
  end
end
