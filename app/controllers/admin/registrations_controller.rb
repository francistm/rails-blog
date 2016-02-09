class Admin::RegistrationsController < AdminController
  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin
    @admin.attributes = admin_params

    if @admin.valid? && @admin.save
      flash[:success] = t 'admin/registrations.admin_update_success'
      redirect_to [:edit, :admin, :registration] and return
    end

    flash.now[:danger] = @admin.errors.full_messages
    render action: :edit
  end

  private

  def admin_params
    params.require(:admin).permit(
      :nickname
    )
  end
end
