module Importer
  class Jekyll
    def initialize(content:, filename:)
      @parser = JekyllParser.new(
          content: content,
          filename: File.basename(filename)
      )
    end

    def valid?
      return false if @parser.slug.blank?
      return false if @parser.published_at.blank?
      return false unless @parser.header.is_a?(Hash)
      return false if @parser.header[:title].blank?
      return false if @parser.content.blank?

      true
    end

    def invalid?
      !valid?
    end

    def attributes
      return nil unless valid?

      {}.tap do |h|
        h[:slug] = @parser.slug
        h[:published_at] = @parser.published_at

        h[:title] = @parser.header[:title].force_encoding('UTF-8')
        h[:content] = @parser.content.force_encoding('UTF-8')
      end
    end
  end
end