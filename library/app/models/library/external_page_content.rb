module Library
  class ExternalPageContent < ActiveRecord::Base

    belongs_to :page

    PDF_TYPE = 0
    HTML_TYPE = 1

    def is_html
      content_type == HTML_TYPE
    end

  end
end