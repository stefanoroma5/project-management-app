class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    "http://127.0.0.1:3000/projects"
  end

 

end
