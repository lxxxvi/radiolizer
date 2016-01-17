module SessionsHelper

  def log_in
    session[ :logged_in ] = 'YES'
  end

  def log_out
    session[ :logged_in ] = nil
  end

  def logged_in?
    session[ :logged_in ] == 'YES'
  end

end
