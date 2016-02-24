require 'rails_helper'

describe Guests::LinksController do
  describe 'GET #index' do
    it 'render :index template' do
      get :index
      expect(response).to render_template :index
    end
  end
end
