module ApplicationHelper
  def page_title(title='')
    base_title = 'あなたの町の直売所'
    title.present? ? "#{title} | #{base_title}" : base_title
  end
end
