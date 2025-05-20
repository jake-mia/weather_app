class ApplicationController < ActionController::Base

  def page_not_found
    respond_to do |format|
      format.html { render template: 'layouts/error_not_found', status: 404 }
      format.all  { head 404, content_type: "text/html" }
    end
  end

  def server_error
    respond_to do |format|
      format.html { render template: 'layouts/error_server', status: 500 }
      format.all  { head 500, content_type: "text/html"}
    end
  end

end
