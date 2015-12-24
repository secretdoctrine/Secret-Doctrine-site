module Library
  importer = ImportHelper.new
  importer.import_all

  News.create!(body: 'td1 added', news_datetime: DateTime.new(2015, 11, 10, 5, 30), library_news: true)
  News.create!(body: 'td2 added', news_datetime: DateTime.new(2015, 11, 12, 6, 45), library_news: true)
  News.create!(body: 'td3 added', news_datetime: DateTime.new(2015, 11, 14, 18, 37), library_news: true)
end