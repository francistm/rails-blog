module ApplicationHelper
  def flash_mesg(klass, mesgs)
    return flash_mesg_box(klass, mesgs) if mesgs.is_a?(String)
    mesgs.map { |mesg| flash_mesg_box(klass, mesg) }.join if mesgs.is_a?(Array)
  end

  def parse_markdown(content)
    markdown_parser.render content
  end

  private

  def flash_mesg_box(klass, mesg)
    content_tag :div, mesg, class: "alert alert-#{klass}"
  end

  def markdown_parser
    @markdown_parser ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new({
      }),
      {
      }
    )
  end
end
