module Refinery
  module FeedbackEntries
    module Admin
      class FeedbackEntriesController < ::Refinery::AdminController

        crudify :'refinery/feedback_entries/feedback_entry',
                :title_attribute => 'entry_title'

        def index

          @feedback_entries = FeedbackEntry.order(:entry_datetime => :desc)

        end

        def show

        end

        private

        # Only allow a trusted parameter "white list" through.
        def feedback_entry_params
          params.require(:feedback_entry).permit(:poster_name, :poster_email, :entry_title, :entry_text)
        end
      end
    end
  end
end
