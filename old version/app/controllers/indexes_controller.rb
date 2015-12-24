class IndexesController < ApplicationController

  before_action :set_body_class

  def set_body_class
    @body_class = :bluegamma
  end

  def index

  end

end
