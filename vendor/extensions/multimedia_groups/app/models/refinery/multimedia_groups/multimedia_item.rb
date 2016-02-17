module Refinery
  module MultimediaGroups
    class MultimediaItem < Refinery::Core::BaseModel

      belongs_to :multimedia_group

      validates :title, :presence => true, :uniqueness => true

      belongs_to :audio_file, :class_name => '::Refinery::Resource'
      belongs_to :hidef_audio_file, :class_name => '::Refinery::Resource'

      def parent_id=(new_id)
        self.multimedia_group_id = new_id
      end

      def update_position(new_parent_id, old_parent_id, new_position, old_position)

        Refinery::Books::OrderableHelper.process_orderable(self, new_parent_id, old_parent_id, new_position, old_position, MultimediaGroup)

      end

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
