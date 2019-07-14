# frozen_string_literal: true

require 'faker'
require 'rails_helper'

describe Admins::SettingsController do
  before :each do
    sign_in create(:admin), scope: :admin
  end

  describe 'GET #index' do
    it 'render :index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'PUT #update' do
    it 'redirect to admin/settings#index if succeed' do
      put_params = {
        site_name: Faker::Name.name,
        feed_output_count: '15'
      }

      put :update, params: {
        site_setting: put_params
      }

      expect(response).to redirect_to %i[admins settings]
    end
  end
end
