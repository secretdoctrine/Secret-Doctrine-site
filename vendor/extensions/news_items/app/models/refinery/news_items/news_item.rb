module Refinery
  module NewsItems
    class NewsItem < Refinery::Core::BaseModel
      #self.table_name = 'refinery_news_items'
      self.table_name = 'refinery_books_news_items'


      validates :body, :presence => true

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
