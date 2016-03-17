module Refinery
  module Books
    module Admin
      class BookCategoriesController < ::Refinery::AdminController

        crudify :'refinery/books/book_category',
                :title_attribute => 'name'

        def index

          @root = BookCategory.get_root!

        end

        def new

          @book_category = BookCategory.new
          @parent = BookCategory.find(params[:book_category_id])

        end

        def create

          @parent = BookCategory.find(params[:book_category][:book_category_id])

          if (@book_category = BookCategory.create(book_category_params)).valid?
            flash.notice = t(
                'refinery.crudify.created',
                :what => @book_category.name
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
              if @book_category.update_attributes(book_category_params)
              flash.notice = t(
                  'refinery.crudify.updated',
                  :what => "'#{@book_category.name}'"
              )
              create_or_update_successful
              else
                create_or_update_unsuccessful 'edit'
              end
            }
            format.json {
              @book_category.update_position(
                  params[:new_parent].split('book_category_')[1].to_i,
                  params[:old_parent].split('book_category_')[1].to_i,
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
        def book_category_params
          params.require(:book_category).permit(:book_category_id, :name, :is_root, :order_number, :synopsis)
        end
      end
    end
  end
end
