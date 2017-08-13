class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def page_not_found
    respond_to do |format|
      format.html { return redirect_to "#{Rails.application.config.refinery_root}/home/page-not-found" }
      format.all  { render nothing: true, status: 404 }
    end
  end

  def internal_server_error
    respond_to do |format|
      format.html { return redirect_to "#{Rails.application.config.refinery_root}/home/internal-server-error" }
      format.all  { render nothing: true, status: 500 }
    end
  end

end
