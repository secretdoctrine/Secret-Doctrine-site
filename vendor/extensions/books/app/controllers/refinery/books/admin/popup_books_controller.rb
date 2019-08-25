module Refinery
  module Books
    module Admin
      class PopupBooksController < ::Refinery::AdminController

        crudify :'refinery/books/popup_book',
                :title_attribute => 'name'

        def new

          @popup_book = PopupBook.new
          @parent = BookCategory.find(params[:book_category_id])

        end

        def update
          respond_to do |format|

            format.html {
              if @popup_book.update_attributes(popup_book_params)
                flash.notice = t(
                    'refinery.crudify.updated',
                    :what => "'#{@popup_book.name}'"
                )
                create_or_update_successful
              else
                create_or_update_unsuccessful 'edit'
              end
            }
            format.json {
              @popup_book.update_position(
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
        def popup_book_params
          params.require(:popup_book).permit(:name, :name_prefix, :tree_prefix, :name_comment, :order_number,
                                             :book_category_id, :body, :synopsis, :tree_prefix_tooltip, :name_tooltip)
        end
      end
    end
  end
end
