class FileHandlerController < ApplicationController
  def index
  end
  
  def update
    render :json => params[:selected_files].to_json
  end
end