Refinery::Admin::PagesController.class_eval do
  def page_params
    params.require(:page).permit(
        :browser_title, :draft, :link_url, :menu_title, :meta_description,
        :parent_id, :skip_to_first_child, :show_in_menu, :title, :view_template,
        :layout_template, :html_class_name, parts_attributes: [:id, :title, :body, :position]
    )
  end
end