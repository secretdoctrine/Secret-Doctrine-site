class BooksController < ApplicationController

  layout 'layouts/empty_layout.haml', :only => [:index, :show]

  before_action :set_body_class

  def set_body_class
    @body_class = :bluegamma
  end

  def index
  end

  def show
  end

end
