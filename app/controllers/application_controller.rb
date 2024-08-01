class ApplicationController < ActionController::Base
  # action per reindirizzare l'utente sulla pagina dei progetti dopo essersi loggato
  def after_sign_in_path_for(resource)
    projects_url(mode: "m")
  end
end
