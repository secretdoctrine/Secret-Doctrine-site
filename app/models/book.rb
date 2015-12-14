class Book < ActiveRecord::Base

  has_many :pages
  belongs_to :book_category

end
