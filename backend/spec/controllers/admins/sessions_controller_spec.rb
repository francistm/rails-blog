# frozen_string_literal: true

require 'faker'
require 'rails_helper'

describe Admins::SessionsController do
  describe 'GET #new' do
    it 'render :new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    it 'has :danger flash if login failed' do
      login_token = {
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }

      post :create, params: { admin: login_token }
      expect(flash[:danger]).to be_present
    end

    it 'redirect to #new action if login failed' do
      login_token = {
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }

      post :create, params: { admin: login_token }
      expect(response).to redirect_to %i[new admin session]
    end

    it 'redirect to admin/dashboard#index if login success' do
      admin = create(:admin)
      post :create, params: {
        admin: { email: admin.email, password: '12345678' }
      }
      expect(response).to redirect_to root_path
    end
  end

  describe 'DELETE #destroy' do
    it 'has :success flash if logout success' do
      sign_in create(:admin), scope: :admin
      delete :destroy
      expect(flash[:success]).not_to be_blank
    end

    it 'redirect to #new action if logout success' do
      sign_in create(:admin), scope: :admin
      delete :destroy
      expect(response).to redirect_to %i[new admin session]
    end
  end
end
