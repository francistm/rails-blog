require 'faker'
require 'rails_helper'

describe Admins::SettingsController do
  before :each do
    sign_in create(:admin)
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
        :'1' => { var: 'site_name', value: Faker::Name.name },
        :'2' => { var: 'feed_output_count', value: 15 },
      }

      put :update, settings: { site_setting: put_params }

      expect(response).to redirect_to [:admins, :settings]
    end
  end
end
