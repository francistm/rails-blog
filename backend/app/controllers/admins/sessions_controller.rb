# frozen_string_literal: true

class Admins::SessionsController < ::AdminController
  layout 'admin_sessions'
  skip_before_action :authenticate_admin!, only: %i[new create]

  def new
    @admin = Admin.new
  end

  def create
    email = admin_params[:email]
    password = admin_params[:password]

    @admin = Admin.find_by(email: email)

    if @admin.present? && @admin.valid_password?(password)
      sign_in :admin, @admin
      redirect_to(after_sign_in_path_for(@admin)) && return
    end

    flash[:danger] = t 'admin/sessions.sign_in_failed'
    redirect_to %i[new admin session]
  end

  def destroy
    sign_out :admin
    flash[:success] = t 'admin/sessions.sign_out_success'
    redirect_to %i[new admin session]
  end

  private

  def admin_params
    params.require(:admin).permit(:email, :password)
  end
end
