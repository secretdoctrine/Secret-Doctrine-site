module Refinery
  module MultimediaGroups
    class MultimediaItem < Refinery::Core::BaseModel

      belongs_to :multimedia_group

      validates :title, :presence => true, :uniqueness => true

      belongs_to :audio_file, :class_name => '::Refinery::Resource'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
