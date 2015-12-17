class Page < ActiveRecord::Base

  belongs_to :book
  has_many :external_page_contents

  def pdf_content_id

    external_page_contents.find_by_content_type(ExternalPageContent::PDF_TYPE)

  end

  def html_content

    external_page_contents.find_by_content_type(ExternalPageContent::HTML_TYPE)

  end

  def prev

    Page.find_by_book_id_and_internal_order(book.id, internal_order - 1)

  end

  def next

    Page.find_by_book_id_and_internal_order(book.id, internal_order + 1)

  end

  def display_name

    name = I18n.t('importer.page') + ' ' + url_name
    contents_element = book.get_parent_for_page(internal_order)

    return name if contents_element.nil? or contents_element.page_number != internal_order

    name += '. ' + contents_element.name
    name

  end

end
