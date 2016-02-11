require 'faker'
require 'rails_helper'

describe Admin::RegistrationsController do
  before :each do
    sign_in :admin, create(:admin)
  end

  describe 'GET #edit' do
    it 'render :edit view' do
      get :edit
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    it 'redirect with flash if admin nickname update succeed' do
      patch :update, admin: { nickname: Faker::Name.name }

      expect(flash[:success]).not_to be_blank
      expect(response).to redirect_to [:edit, :admin, :registration]
    end

    it 'redirect if admin password update succeed' do
      pwd = '987654321'
      patch :update, admin: { password: pwd, password_confirmation: pwd }

      expect(flash[:success]).not_to be_blank
      expect(response).to redirect_to [:edit, :admin, :registration]
    end

    it 'render :edit view if admin profile invalid' do
      patch :update, admin: { nickname: '' }

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :edit
    end

    it 'render :edit view if new password not matched' do
      patch :update, admin: { password: '12345678', password_confirmation: '87654321' }

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :edit
    end

    it 'render :edit with flash if new password invalid' do
      patch :update, admin: { password: '123456', password_confirmation: '123456' }

      expect(flash[:danger]).not_to be_blank
      expect(response).to render_template :edit
    end
  end
end
