class PageController < ApplicationController

  layout 'layouts/application.haml', :only => [:index, :show]

  before_action :set_body_class

  def set_body_class
    @body_class = :bluegamma
  end

  def show
  end

  def index
  end
end
