module Refinery
  module Books
    class ExternalBookContent < Refinery::Core::BaseModel

      belongs_to :book

      PDF_TYPE = 0

    end
  end
end