# frozen_string_literal: true

class Admins::RegistrationsController < AdminController
  def edit
    @admin = current_admin
  end

  def update
    password_changed = false

    @admin = current_admin
    @admin.attributes = admin_attribute_params

    if admin_password_params[:password].present?
      password_changed = true
      @admin.attributes = admin_password_params
    end

    if @admin.valid? && @admin.save
      bypass_sign_in @admin if password_changed

      flash[:success] = t 'admin/registrations.admin_update_success'
      redirect_to(%i[edit admin registration]) && return
    end

    flash.now[:danger] = @admin.errors.full_messages
    render action: :edit
  end

  private

  def admin_attribute_params
    params.require(:admin).permit(
      :nickname
    )
  end

  def admin_password_params
    params.require(:admin).permit(
      :password,
      :password_confirmation
    )
  end
end
