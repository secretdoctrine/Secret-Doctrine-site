module Library
  importer = ImportHelper.new
  importer.import_all

  NewsItem.create!(title: 'заголовок 1', body: 'td1 added', news_datetime: DateTime.new(2015, 11, 10, 5, 30), library_news: true, site_news:false)
  NewsItem.create!(title: 'заголовок 2', body: 'td2 added', news_datetime: DateTime.new(2015, 11, 12, 6, 45), library_news: true, site_news:false)
  NewsItem.create!(title: 'заголовок 3', body: 'td3 added', news_datetime: DateTime.new(2015, 11, 14, 18, 37), library_news: true, site_news:false)
end