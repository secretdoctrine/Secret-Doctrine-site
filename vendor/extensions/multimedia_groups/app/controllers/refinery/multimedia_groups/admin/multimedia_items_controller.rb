module Refinery
  module MultimediaGroups
    module Admin
      class MultimediaItemsController < ::Refinery::AdminController

        before_filter :find_all_multimedia_groups
        crudify :'refinery/multimedia_groups/multimedia_item'

        def new

          @multimedia_item = MultimediaItem.new
          @parent = MultimediaGroup.find(params[:multimedia_group_id])

        end

        def create

          @parent = MultimediaGroup.find(params[:multimedia_item][:multimedia_group_id])

          if (@multimedia_item = MultimediaItem.create(multimedia_item_params)).valid?
            flash.notice = t(
                'refinery.crudify.created',
                :what => @multimedia_item.title
            )
            create_or_update_successful
          else
            #@book = Book.new
            create_or_update_unsuccessful 'new'
          end

        end

        def update
          respond_to do |format|

            format.html {
              if @multimedia_item.update_attributes(multimedia_item_params)
                flash.notice = t(
                    'refinery.crudify.updated',
                    :what => "'#{@multimedia_item.title}'"
                )
                create_or_update_successful
              else
                create_or_update_unsuccessful 'edit'
              end
            }
            format.json {
              @multimedia_item.update_position(
                  params[:new_parent].split('group_')[1].to_i,
                  params[:old_parent].split('group_')[1].to_i,
                  params[:new_position].to_i,
                  params[:old_position].to_i)
              render :nothing => true
            }
          end
        end

        private

        def create_or_update_unsuccessful(action)

          redirect_to :back

        end

        # Only allow a trusted parameter "white list" through.
        def multimedia_item_params
          params.require(:multimedia_item).permit(
              :audio_file_id, :hidef_audio_file_id, :title, :video_link, :book_link, :multimedia_group_id, :order_number)
        end

        def find_all_multimedia_groups
          @multimedia_groups = Refinery::MultimediaGroups::MultimediaGroup.all
        end

      end
    end
  end
end
