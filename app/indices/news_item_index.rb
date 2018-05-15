ThinkingSphinx::Index.define 'refinery/news/news_item', :with => :active_record do
  # fields
  indexes title
  indexes body

  has item_categories.news_items_news_category_id as categories_ids
  has news_datetime
end