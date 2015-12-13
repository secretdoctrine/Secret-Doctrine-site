class PageController < ApplicationController

  layout 'layouts/application.haml', :only => [:index, :show]

  def show
  end

  def index
  end
end
