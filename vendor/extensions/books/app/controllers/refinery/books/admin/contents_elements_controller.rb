module Refinery
  module Books
    module Admin
      class ContentsElementsController < ::Refinery::AdminController

        crudify :'refinery/books/contents_element',
                :title_attribute => 'name'

        def update

          old_page_number = @contents_element.page_number
          @contents_element.update_attributes(contents_element_params)
          new_page_number = @contents_element.page_number

          return render :update if old_page_number == new_page_number

          redirect_to refinery.books_admin_contents_elements_path({:book_id => @contents_element.book_id,
                                                                   :scroll_id => @contents_element.id})

        end

        def create

          @contents_element = ContentsElement.create(contents_element_params)
          book = Book.find_by_id(@contents_element.book_id)
          return render :nothing => true if book.nil?
          redirect_to refinery.books_admin_contents_elements_path({:book_id => @contents_element.book_id,
                                                                   :scroll_id => @contents_element.id})

        end

        def destroy
          book = Book.find_by_id(@contents_element.book_id)
          return render :nothing => true if book.nil?
          @contents_element.destroy
          redirect_to refinery.books_admin_contents_elements_path({:book_id => book.id}), :status => :see_other
        end

        def index

          @contents_elements = []
          book = Book.find_by_id(params[:book_id])
          return render :nothing => true if book.nil?
          @contents_elements = book.contents_elements.sort_by{|x| [x.page_number, x.get_nest_level]}
          @scroll_element = nil
          @scroll_element = ContentsElement.find_by_id(params[:scroll_id]) if params.has_key? :scroll_id

        end

        private

        # Only allow a trusted parameter "white list" through.
        def contents_element_params
          params.require(:contents_element).permit(:book_id, :page_number, :name_prefix, :name, :name_comment, :ce_type)
        end

      end
    end
  end
end