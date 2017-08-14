module Refinery
  module Books
    module Admin
      class BooksController < ::Refinery::AdminController

        crudify :'refinery/books/book',
                :title_attribute => 'name'

        def new

          @book = Book.new
          @parent = BookCategory.find(params[:book_category_id])
          @import_options = Importer.books_to_load

        end

        def edit
          @new_contents_element = ContentsElement.new
          @new_contents_element.book_id = @book.id
          @new_contents_element.ce_type = ContentsElement::SECTION_CE_TYPE
          @new_contents_element.name = ::I18n.t('contents_elements.new_section')
          @new_contents_element.page_number = 1

          @import_options = Importer.books_to_load

        end

        def update
          respond_to do |format|

            format.html {
              @parent = BookCategory.find(params[:book][:book_category_id])
              @import_options = Importer.books_to_load

              if params.has_key? :file_upload
                result = Importer.import_yaml(@book, params[:file_upload], params[:book][:book_category_id].to_i, params[:book][:order_number].to_i)
                @book = result[:book]
                if result[:success]
                  flash.notice = t(
                      'refinery.crudify.updated',
                      :what => @book.name
                  )
                else
                  flash.alert = result[:message]
                end
                redirect_to refinery.edit_books_admin_book_path(@book.id)
              else
                if @book.update_attributes(book_params)
                  flash.notice = t(
                      'refinery.crudify.updated',
                      :what => "'#{@book.name}'"
                  )
                  create_or_update_successful
                else
                  create_or_update_unsuccessful 'edit'
                end
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

        def create

          @parent = BookCategory.find(params[:book][:book_category_id])
          @import_options = Importer.books_to_load

          if params.has_key? :file_upload
            result = Importer.import_yaml(Book.new, params[:file_upload], params[:book][:book_category_id].to_i, params[:book][:order_number].to_i)
            @book = result[:book]
            if result[:success]
              flash.notice = t(
                  'refinery.crudify.created',
                  :what => @book.name
              )
              create_or_update_successful
            else
              flash.alert = result[:message]
              @book = Book.new
              create_or_update_unsuccessful 'new'
            end
          else
            if (@book = Book.create(book_params)).valid?
              flash.notice = t(
                  'refinery.crudify.created',
                  :what => @book.name
              )
              create_or_update_successful
            else
              #@book = Book.new
              create_or_update_unsuccessful 'new'
            end
          end

        end

        private

        def create_or_update_unsuccessful(action)

          redirect_to :back

        end

        # Only allow a trusted parameter "white list" through.
        def book_params
          params.require(:book).permit(:name, :name_prefix, :tree_prefix, :name_comment, :order_number, :cover_picture_id,
                                       :synopsis, :year, :author, :page_count, :can_buy, :book_category_id, :page_format,
                                       :taggable_name)
        end
      end
    end
  end
end
