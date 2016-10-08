module Importer
  class JekyllParser
    MATCH_REGEX = /\A---(.+?)---(.+)\z/m.freeze
    FILENAME_REGEX = /\A(\d{4}-\d{2}-\d{2})-(.+)\.\w+\z/.freeze
    HEADER_HASH_REGEX = /\A(.+?):\s+['"]?(.+?)['"]?\z/.freeze

    attr_reader :slug, :header, :content, :published_at

    def initialize(content:, filename:)
      parse_raw_content content
      parse_raw_filename filename
    end

    private

    def parse_raw_content(raw_content)
      return unless raw_content.is_a?(String)

      matches = raw_content.match MATCH_REGEX

      return if matches.blank?

      @header = parse_header matches[1]
      @content = parse_content matches[2]
    end

    def parse_raw_filename(raw_filename)
      return unless raw_filename.is_a?(String)

      matches = raw_filename.match FILENAME_REGEX
      return if matches.blank? || matches.to_a.length < 3

      @slug = matches[2]
      @published_at = matches[1]
    end

    def parse_header(raw_header)
      header = Hash.new
      raw_header.lines.each do |raw_line|
        matches = raw_line.chomp.match HEADER_HASH_REGEX
        next if matches.blank?
        header.store matches[1].to_sym, matches[2]
      end

      header
    end

    def parse_content(raw_content)
      raw_content.strip
    end
  end
end