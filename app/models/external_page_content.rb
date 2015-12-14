class ExternalPageContent < ActiveRecord::Base

  belongs_to :page

  PDF_TYPE = 0
  HTML_TYPE = 1

end
