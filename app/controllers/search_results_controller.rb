class SearchResultsController < ApplicationController

  layout 'layouts/library.haml', :only => [:index]

  before_action :set_body_class

  def set_body_class
    @body_class = 'bluegamma'
  end

  def index

    @result = Page.sphinx_search(params)

  end

  def export



  end

end