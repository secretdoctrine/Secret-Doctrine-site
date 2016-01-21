module Refinery
  module MultimediaGroups
    module Admin
      class MultimediaItemsController < ::Refinery::AdminController

        before_filter :find_all_multimedia_groups
        crudify :'refinery/multimedia_groups/multimedia_item'

        private

        # Only allow a trusted parameter "white list" through.
        def multimedia_item_params
          params.require(:multimedia_item).permit(:audio_file_id, :title, :video_link, :book_link, :multimedia_group_id)
        end

        def find_all_multimedia_groups
          @multimedia_groups = Refinery::MultimediaGroups::MultimediaGroup.all
        end

      end
    end
  end
end
