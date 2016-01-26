#Refinery::I18n.frontend_locales.each do |lang|
#  I18n.locale = lang
#
#  Refinery::User.find_each do |user|
#    user.plugins.where(name: 'refinerycms-books').first_or_create!(
#      position: (user.plugins.maximum(:position) || -1) +1
#    )
#  end if defined?(Refinery::User)
#
#  Refinery::Page.where(link_url: (url = "/books")).first_or_create!(
#    title: 'Books#',
#    deletable: false,
#    menu_match: "^#{url}(\/|\/.+?|)$"
#  ) do |page|
#    Refinery::Pages.default_parts.each_with_index do |part, index|
#      page.parts.build title: part, body: nil, position: index
#    end
#  end if defined?(Refinery::Page)
#end
Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang

  Refinery::User.find_each do |user|
    user.plugins.where(name: 'refinerycms-books').first_or_create!(
      position: (user.plugins.maximum(:position) || -1) +1
    )
  end if defined?(Refinery::User)

  Refinery::Page.where(link_url: (url = "#{Rails.application.config.refinery_root}/book_categories")).first_or_create!(
    title: 'Book Categories',
    deletable: false,
    menu_match: "^#{url}(\/|\/.+?|)$",
    html_class_name: 'bluegamma'
  ) do |page|
    Refinery::Pages.default_parts.each_with_index do |part, index|
      page.parts.build title: part, body: nil, position: index
    end
  end if defined?(Refinery::Page)
end

importer = Refinery::Books::ImportHelper.new
importer.import_all

Refinery::Books::NewsItem.create!(title: 'заголовок 1', body: 'td1 added', news_datetime: DateTime.new(2015, 11, 10, 5, 30), library_news: true, site_news:false)
Refinery::Books::NewsItem.create!(title: 'заголовок 2', body: 'td2 added', news_datetime: DateTime.new(2015, 11, 12, 6, 45), library_news: true, site_news:false)
Refinery::Books::NewsItem.create!(title: 'заголовок 3', body: 'td3 added', news_datetime: DateTime.new(2015, 11, 14, 18, 37), library_news: true, site_news:false)
