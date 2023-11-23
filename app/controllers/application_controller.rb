class ApplicationController < ActionController::Base
   before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute1, :attribute2])
  end

  protected

  def after_sign_out_path_for(resource)
    new_user_registration_path
  end
end
