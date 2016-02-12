require Rails.root.join('lib', 'importer', 'jekyll')

class JekyllImport
  include ActiveModel::Model

  attr_accessor :post

  validate :upload_post_must_be_valid_jekyll_post

  def parse
    return false unless valid?

    jekyll_parser.attributes
  end

  def attributes=(hash)
    hash.each do |key, value|
      send "#{key}=", value
    end
  end

  def upload_post_must_be_valid_jekyll_post
    if post.blank?
      errors.add :post, :not_blank
    elsif jekyll_parser.invalid?
      errors.add :post, :invalid_jekyll_format
    end
  end

  def jekyll_parser
    @jekyll_parser ||= Importer::Jekyll.new(
      content: post.read,
      filename: File.basename(post.original_filename)
    )
  end
end
