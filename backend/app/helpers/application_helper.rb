# frozen_string_literal: true

module ApplicationHelper
  def flash_mesg(klass, mesgs)
    return flash_mesg_box(klass, mesgs) if mesgs.is_a?(String)

    mesgs.map { |mesg| flash_mesg_box(klass, mesg) }.join if mesgs.is_a?(Array)
  end

  def parse_markdown(content)
    markdown_parser.render content
  end

  private

  class HTMLWithPygments < Redcarpet::Render::HTML
    def block_code(code, lang)
      lang = 'text' if lang.blank?
      Pygments.highlight code, lexer: lang
    end
  end

  def flash_mesg_box(klass, mesg)
    content_tag :div, mesg, class: "alert alert-#{klass}"
  end

  def markdown_parser
    @markdown_parser ||= Redcarpet::Markdown.new(
      markdown_parser_render,
      markdown_parser_options
    )
  end

  def markdown_parser_render
    HTMLWithPygments.new(
      hard_wrap: false,
      filter_html: true,
      link_attributes: { rel: 'external nofollow' }
    )
  end

  def markdown_parser_options
    {}.tap do |h|
      h[:quote] = true
      h[:autolink] = true
      h[:fenced_code_blocks] = true
    end
  end
end
