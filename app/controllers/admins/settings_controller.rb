class Admins::SettingsController < AdminController
  def index
    @site_settings = SiteSetting.unscoped
  end

  def update
    setting_params[:site_setting].each do |id, setting|
      SiteSetting.send "#{setting[:var]}=", setting[:value]
    end

    flash[:success] = t 'admin/settings.setting_update_success'
    redirect_to [:admins, :settings]
  end

  private

  def setting_params
    params.require(:settings).permit(
      site_setting: [:var, :value]
    )
  end
end
