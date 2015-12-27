module Refinery
  module Authors
    class Poem < Refinery::Core::BaseModel

      belongs_to :author

      validates :content, :presence => true, :uniqueness => true

      belongs_to :picture, :class_name => '::Refinery::Image'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
