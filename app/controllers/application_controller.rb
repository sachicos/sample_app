class ApplicationController < ActionController::Base
  def hello
    render html: "Hi!"
  end
end
