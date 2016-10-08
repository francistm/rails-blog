class JekyllImport
  include ActiveModel::Model

  attr_accessor :post
  validate :validate_jekyll_post

  def parse
    return {} unless valid?
    jekyll_parser.attributes
  end

  def jekyll_parser
    @jekyll_parser ||= Importer::Jekyll.new(
        content: post.try(:read),
        filename: File.basename(post.try(:original_filename) || String.new)
    )
  end

  private

  def validate_jekyll_post
    errors.add :post, :not_blank if post.blank?
    errors.add :post, :invalid_jekyll_format if jekyll_parser.invalid?
  end
end