class ApplicationController < ActionController::Base

  # action per reindirizzare l'utente sulla pagina dei progetti dopo essersi loggato
  def after_sign_in_path_for(resource)
    #redirect_to @projects
    "http://127.0.0.1:3000/projects?mode=m"
  end

end
