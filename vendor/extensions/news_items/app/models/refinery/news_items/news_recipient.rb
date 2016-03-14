module Refinery
  module NewsItems
    class NewsRecipient < Refinery::Core::BaseModel
      #self.table_name = 'refinery_news_items'
      #self.table_name = 'refinery_books_news_items'
      mailkick_user


      validates :email, :presence => true, :uniqueness => true, length: {maximum: 255}
      validates :name, length: {maximum: 255}
      validates :city, length: {maximum: 255}

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
