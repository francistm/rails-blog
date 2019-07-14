# frozen_string_literal: true

require 'rails_helper'

describe Admins::DashboardController do
  before :each do
    sign_in create(:admin), scope: :admin
  end

  describe 'GET #index' do
    it 'render :index template' do
      get :index
      expect(response).to render_template :index
    end
  end
end
