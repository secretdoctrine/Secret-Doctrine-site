class ContentsElement < ActiveRecord::Base

  belongs_to  :book
  belongs_to  :contents_element
  has_many    :contents_elements

  SECTION_CE_TYPE = 0
  CHAPTER_CE_TYPE = 1
  PART_CE_TYPE = 2
  PAGE_CE_TYPE = 3

  SECTION_CE_TYPE_NAME = 'section'
  CHAPTER_CE_TYPE_NAME = 'chapter'
  PART_CE_TYPE_NAME = 'part'
  PAGE_CE_TYPE_NAME = 'page'

  def get_class_name

    return SECTION_CE_TYPE_NAME if ce_type == SECTION_CE_TYPE
    return CHAPTER_CE_TYPE_NAME if ce_type == CHAPTER_CE_TYPE
    return PART_CE_TYPE_NAME    if ce_type == PART_CE_TYPE
    return PAGE_CE_TYPE_NAME    if ce_type == PAGE_CE_TYPE

    ''

  end

end
