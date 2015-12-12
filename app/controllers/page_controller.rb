class PageController < ApplicationController

  layout 'layouts/empty_layout.haml', :only => [:index, :show]

  def show
  end

  def index
  end
end
