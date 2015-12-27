module Refinery
  module Authors
    class Author < Refinery::Core::BaseModel
      extend FriendlyId
        friendly_id :friendly_header, :use => [:slugged]
      self.table_name = 'refinery_authors'

      has_many :poems

      validates :name, :presence => true, :uniqueness => true

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
