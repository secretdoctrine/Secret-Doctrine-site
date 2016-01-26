module Refinery
  module Books
    class Book < Refinery::Core::BaseModel
      self.table_name = 'refinery_books'


      validates :name, :presence => true, :uniqueness => true

      belongs_to :picture_path, :class_name => '::Refinery::Resource'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
