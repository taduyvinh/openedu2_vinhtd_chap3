module ApplicationHelper
  def full_title page_title = ""
    base_title = t "base_title"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def flash_type type
    {success: "alert alert-success", error: "alert alert-danger"}[type.to_sym]
  end
end
