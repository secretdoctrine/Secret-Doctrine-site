module Library
  class ExternalBookContent < ActiveRecord::Base

    belongs_to :book

    PDF_TYPE = 0

  end
end