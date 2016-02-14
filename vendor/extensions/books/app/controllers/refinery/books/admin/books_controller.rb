module Refinery
  module Books
    module Admin
      class BooksController < ::Refinery::AdminController

        crudify :'refinery/books/book',
                :title_attribute => 'name'

        def new

          @book = Book.new
          @parent = BookCategory.find(params[:book_category_id])

        end

        def update
          respond_to do |format|

            format.html {
              if @book.update_attributes(book_params)
                flash.notice = t(
                    'refinery.crudify.updated',
                    :what => "'#{@book.name}'"
                )
                create_or_update_successful
              else
                create_or_update_unsuccessful 'edit'
              end
            }
            format.json {
              @book.update_position(
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
        def book_params
          params.require(:book).permit(:name, :name_prefix, :tree_prefix, :name_comment, :order_number, :picture_path_id, :synopsis, :year, :author, :page_count, :can_buy, :book_category_id)
        end
      end
    end
  end
end
