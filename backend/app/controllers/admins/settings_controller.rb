class Admins::SettingsController < AdminController
  def index
    @site_settings = setting_list.map do |setting_var|
      {}.tap do |h|
        h[:var] = setting_var
        h[:value] = SiteSetting.send(setting_var)
      end
    end
  end

  def update
    setting_params.each do |value|
      SiteSetting.send "#{value[0]}=", value[1]
    end

    flash[:success] = t 'admin/settings.setting_update_success'
    redirect_to [:admins, :settings]
  end

  private

  def setting_list
    [].tap do |arr|
      arr << :site_name
      arr << :feed_output_count
    end
  end

  def setting_params
    params.require(:site_setting).permit(*setting_list)
  end
end
