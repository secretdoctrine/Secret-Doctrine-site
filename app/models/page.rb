class Page < ActiveRecord::Base

  belongs_to :book
  has_many :external_page_contents

  def pdf_content_id

    external_page_contents.find_by_content_type(ExternalPageContent::PDF_TYPE)

  end

  def html_content

    external_page_contents.find_by_content_type(ExternalPageContent::HTML_TYPE)

  end

end
