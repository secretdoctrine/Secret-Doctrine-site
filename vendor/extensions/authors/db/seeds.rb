Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang

  Refinery::User.find_each do |user|
    user.plugins.where(name: 'refinerycms-authors').first_or_create!(
      position: (user.plugins.maximum(:position) || -1) +1
    )
  end if defined?(Refinery::User)

  Refinery::Page.where(link_url: (url = "#{Rails.application.config.refinery_root}/authors")).first_or_create!(
    title: 'Authors',
    deletable: false,
    html_class_name: 'bluegamma',
    menu_match: "^#{url}(\/|\/.+?|)$"
  ) do |page|
    Refinery::Pages.default_parts.each_with_index do |part, index|
      page.parts.build title: part, body: nil, position: index
    end
  end if defined?(Refinery::Page)
end
Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang

  Refinery::User.find_each do |user|
    user.plugins.where(name: 'refinerycms-authors').first_or_create!(
      position: (user.plugins.maximum(:position) || -1) +1
    )
  end if defined?(Refinery::User)

  #Refinery::Page.where(link_url: (url = "#{Rails.application.config.refinery_root}/authors/poems")).first_or_create!(
  #  title: 'Poems',
  #  deletable: false,
  #  html_class_name: 'bluegamma',
  #  menu_match: "^#{url}(\/|\/.+?|)$"
  #) do |page|
  #  Refinery::Pages.default_parts.each_with_index do |part, index|
  #    page.parts.build title: part, body: nil, position: index
  #  end
  #end if defined?(Refinery::Page)
end
