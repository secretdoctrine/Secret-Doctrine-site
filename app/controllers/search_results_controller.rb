class SearchResultsController < ApplicationController

  def index

    @result = Page.sphinx_search(params)

  end

  def export



  end

end