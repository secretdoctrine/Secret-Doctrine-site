module Refinery
  module MultimediaGroups
    module Admin
      class MultimediaGroupsController < ::Refinery::AdminController

        before_filter :find_all_multimedia_groups
        crudify :'refinery/multimedia_groups/multimedia_group'

        private

        # Only allow a trusted parameter "white list" through.
        def multimedia_group_params
          params.require(:multimedia_group).permit(:title, :multimedia_group_id)
        end

        def find_all_multimedia_groups
          @multimedia_groups = Refinery::MultimediaGroups::MultimediaGroup.all
        end

      end
    end
  end
end
