module Refinery
  module Books
    class ContentsElement < Refinery::Core::BaseModel

      belongs_to  :book
      belongs_to  :contents_element
      has_many    :contents_elements

      SECTION_CE_TYPE = 0
      CHAPTER_CE_TYPE = 1
      PART_CE_TYPE = 2
      PAGE_CE_TYPE = 3

      NEST_LEVEL_SECTION_CE_TYPE = 0
      NEST_LEVEL_CHAPTER_CE_TYPE = 1
      NEST_LEVEL_PART_CE_TYPE = 2
      NEST_LEVEL_PAGE_CE_TYPE = 3


      SECTION_CE_TYPE_NAME = 'section'
      CHAPTER_CE_TYPE_NAME = 'chapter'
      PART_CE_TYPE_NAME = 'part'
      PAGE_CE_TYPE_NAME = 'page'

      def get_nest_level

        return NEST_LEVEL_SECTION_CE_TYPE if ce_type == SECTION_CE_TYPE
        return NEST_LEVEL_CHAPTER_CE_TYPE if ce_type == CHAPTER_CE_TYPE
        return NEST_LEVEL_PART_CE_TYPE    if ce_type == PART_CE_TYPE
        return NEST_LEVEL_PAGE_CE_TYPE    if ce_type == PAGE_CE_TYPE

        nil

      end

      def get_class_name

        return SECTION_CE_TYPE_NAME if ce_type == SECTION_CE_TYPE
        return CHAPTER_CE_TYPE_NAME if ce_type == CHAPTER_CE_TYPE
        return PART_CE_TYPE_NAME    if ce_type == PART_CE_TYPE
        return PAGE_CE_TYPE_NAME    if ce_type == PAGE_CE_TYPE

        ''

      end

      def array_for_select

        [[::I18n.t('contents_elements.section'), SECTION_CE_TYPE],
         [::I18n.t('contents_elements.chapter'), CHAPTER_CE_TYPE],
         [::I18n.t('contents_elements.part'), PART_CE_TYPE],
         [::I18n.t('contents_elements.page'), PAGE_CE_TYPE]]

      end

    end
  end
end