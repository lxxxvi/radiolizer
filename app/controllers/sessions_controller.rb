class SessionsController < ApplicationController
  def new
  end

  def create

    if session_params[:password] == Rails.application.secrets.admin_password
      log_in
      redirect_to root_path, notice: 'Login successful'
    else
      render :new, notice: 'Login failed'
    end
  end

  def destroy
    log_out
    redirect_to root_path, notice: 'Logout successful'
  end

  private
    def session_params
      params.require( :session ).permit( :password )
    end
end
