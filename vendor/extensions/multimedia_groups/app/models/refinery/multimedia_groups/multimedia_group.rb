module Refinery
  module MultimediaGroups
    class MultimediaGroup < Refinery::Core::BaseModel
      belongs_to :multimedia_group
      has_many :multimedia_groups
      has_many :multimedia_items
      self.table_name = 'refinery_multimedia_groups'


      validates :title, :presence => true, :uniqueness => true

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
