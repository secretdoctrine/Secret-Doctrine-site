class BooksController < ApplicationController

  layout 'layouts/application.haml', :only => [:index, :show]

  before_action :set_body_class

  def set_body_class
    @body_class = :bluegamma
  end

  def show

    @book = Book.includes(:pages).find_by_id(params[:id])

    return render(layout:false, status: 404) if @book.nil?

    redirect_to book_page_path(@book, @book.pages.sort { |x, y| x.internal_order <=> y.internal_order}.first.internal_order)

  end

end
