class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  # before_filter :authenticate_from_token!

  def authenticate_from_token!
    token = params.delete(:api_token)
    if !token || !Devise.secure_compare(Rails.application.secrets.api_token, token)
      render nothing: true, status: :unauthorized
    end
  end
end
