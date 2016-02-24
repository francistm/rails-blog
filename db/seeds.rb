SiteSetting.save_default :site_name, ''
SiteSetting.save_default :feed_output_count, 5

Admin.create!(email: 'francis.tm@gmail.com', password: '123456789', nickname: 'admin') unless Admin.exists?