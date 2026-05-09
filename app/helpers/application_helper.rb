module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: true,
      with_toc_data: false
    )
    options = {
      autolink: true,
      fenced_code_blocks: true,
      tables: true,
      strikethrough: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
end
