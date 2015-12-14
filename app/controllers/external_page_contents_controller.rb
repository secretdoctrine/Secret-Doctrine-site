class ExternalPageContentsController < ApplicationController

  def show

    @content_item = ExternalPageContent.find_by_id(params[:id])
    return render_404 if @content_item.nil?
    return render_404 unless File.exist?(@content_item.path)

    @content = File.read(@content_item.path)

    render :layout => false

  end

end