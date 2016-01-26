ThinkingSphinx::Index.define 'refinery/books/book_page', :with => :active_record do
  # fields
  indexes page_text

  has book_id
  has book.book_category_id
  has internal_order
end