class BooksController < ApplicationController

  layout 'layouts/application.haml', :only => [:index, :show]

  before_action :set_body_class

  def set_body_class
    @body_class = :bluegamma
  end

  def index

    @tree = BookCategory.build_categories_tree

  end

  def show
  end

end
