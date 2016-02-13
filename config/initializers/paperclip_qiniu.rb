Paperclip::Attachment.default_options.tap do |options|
  options[:storage] = :qiniu
  options[:qiniu_credentials] = {
    access_key: ENV['QINIU_ACCESS_KEY'],
    secret_key: ENV['QINIU_SECRET_KEY'],
  }

  options[:bucket] = 'heroku-blog'
  options[:use_timestamp] = false
  options[:qiniu_host] = ENV['QINIU_HOST']
end
