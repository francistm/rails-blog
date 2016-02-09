module ApplicationHelper
  def flash_mesg(klass, mesgs)
    return flash_mesg_box(klass, mesgs) if mesgs.is_a?(String)
    mesgs.map { |mesg| flash_mesg_box(klass, mesg) }.join if mesgs.is_a?(Array)
  end

  private

  def flash_mesg_box(klass, mesg)
    content_tag :div, mesg, class: "alert alert-#{klass}"
  end
end
