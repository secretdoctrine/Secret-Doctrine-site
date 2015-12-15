# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#root_category = BookCategory.find_by(name: 'root')
#root_category = BookCategory.create!(name: 'root', is_root: true, order_number: 0) if root_category.nil?

importer = BookHelper::Importer.new
importer.import_all

News.create!(body: 'td1 added', news_datetime: DateTime.new(2015, 11, 10, 5, 30), library_news: true)
News.create!(body: 'td2 added', news_datetime: DateTime.new(2015, 11, 12, 6, 45), library_news: true)
News.create!(body: 'td3 added', news_datetime: DateTime.new(2015, 11, 14, 18, 37), library_news: true)