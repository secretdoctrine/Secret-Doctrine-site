class ContentsElement < ActiveRecord::Base

  belongs_to  :book
  belongs_to  :contents_element
  has_many    :contents_elements

end
