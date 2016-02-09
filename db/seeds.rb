SiteSetting.site_name = ''
Admin.create!(email: 'francis.tm@gmail.com', password: '123456789', nickname: 'admin') unless Admin.exists?
