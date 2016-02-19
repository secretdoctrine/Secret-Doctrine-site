module Refinery
  module FeedbackEntries
    class FeedbackEntry < Refinery::Core::BaseModel
      self.table_name = 'refinery_feedback_entries'

      MAX_ELEMENT_LENGTH = 20

      mount_uploader :attachment, FeedbackAttachmentUploader
      validates :poster_name, :presence => true
      validates :entry_title, :presence => true

      def self.create(params)
        params[:entry_datetime] = Time.now
        super(params)
      end

      def self.create!(params)
        params[:entry_datetime] = Time.now
        super(params)
      end

      def title

        title = ''
        title << (entry_title.length > MAX_ELEMENT_LENGTH ? entry_title[0..MAX_ELEMENT_LENGTH - 1] << "..." : entry_title)
        title << ' ('
        title << (poster_name.length > MAX_ELEMENT_LENGTH ? poster_name[0..MAX_ELEMENT_LENGTH - 1] << "..." : poster_name)
        title << ')'

      end

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
