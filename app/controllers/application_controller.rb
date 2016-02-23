class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # FIXME: correct place?
  def mime_extension(mime_type)
    case mime_type
    when Mime[:html]
      ''
    when Mime[:pdf]
      'pdf'
    when Mime[:txt]
      'txt'
    when Mime[:json]
      'json'
    else
      ''
    end
  end
end
