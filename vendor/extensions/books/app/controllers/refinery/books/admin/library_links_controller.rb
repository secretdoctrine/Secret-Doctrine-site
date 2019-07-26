module Refinery
  module Books
    module Admin
      class LibraryLinksController < ::Refinery::AdminController

        crudify :'refinery/books/library_link',
                :title_attribute => 'name'

        def new

          @library_link = LibraryLink.new
          @parent = BookCategory.find(params[:book_category_id])

        end

        def update
          respond_to do |format|

            format.html {
              if @library_link.update_attributes(library_link_params)
                flash.notice = t(
                    'refinery.crudify.updated',
                    :what => "'#{@library_link.name}'"
                )
                create_or_update_successful
              else
                create_or_update_unsuccessful 'edit'
              end
            }
            format.json {
              @library_link.update_position(
                  params[:new_parent].split('book_category_')[1].to_i,
                  params[:old_parent].split('book_category_')[1].to_i,
                  params[:new_position].to_i,
                  params[:old_position].to_i)
              render :nothing => true
            }
          end
        end

        private

        # Only allow a trusted parameter "white list" through.
        def library_link_params
          params.require(:library_link).permit(:name, :name_prefix, :tree_prefix, :name_comment, :order_number,
                                             :book_category_id, :link, :synopsis, :cover_picture_id)
        end
      end
    end
  end
end
