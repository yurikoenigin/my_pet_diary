class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def after_sign_in_path_for(resource)
    pets_path
  end

  protected

  def configure_permitted_parameters
    # 新規登録時にnameを許容
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    # アカウント編集時にnameを許容
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end
end
