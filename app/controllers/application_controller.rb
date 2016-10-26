class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :user_activity
  before_action :ensure_signup_complete

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end

  def ensure_signup_complete
    # Убеждаемся, что цикл не бесконечный
    return if action_name == 'finish_signup'

    # Редирект на адрес 'finish_signup' если пользователь
    # не подтвердил свою почту
		unless (action_name == 'destroy' && controller_name == 'sessions') || controller_name == 'confirmations'
	    if current_user && !current_user.email_verified?
	      redirect_to finish_signup_path(current_user)
	    end
		end
  end

  protected

	  def configure_permitted_parameters
	      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:gender, :first_name, :last_name, :email, :password, :password_confirmation) }
	      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:gender, :birth_date, :country_id, :state_id, :city_id, :avatar, :first_name, :last_name, :email, :password, :password_confirmation) }
	  end

	private

		def user_activity
		  current_user.try :touch
		end	

end
