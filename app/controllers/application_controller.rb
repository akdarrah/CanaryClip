class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_admin_user!
    if current_user.blank? || !current_user.admin?
      redirect_to root_url
    end
  end

  def current_character
    @current_character ||= current_user.try(:current_character)
  end

  def require_current_character
    if current_character.blank?
      redirect_to root_url
    end
  end
end
