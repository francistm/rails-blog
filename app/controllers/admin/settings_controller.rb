class Admin::SettingsController < AdminController
  def index
    @site_settings = SiteSetting.unscoped
  end

  def update
    setting_params.each do |key, setting|
      SiteSetting.send "#{setting[:var]}=", setting[:value]
    end

    flash[:success] = t 'admin/settings.setting_update_success'
    redirect_to [:admin, :settings]
  end

  private

  def setting_params
    params.require(:settings).permit(
      site_setting: [:var, :value]
    )
  end
end
