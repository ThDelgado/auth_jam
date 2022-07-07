class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      redirect_to root_path, notice: 'Logeado correctamente'
    else
      flash.now[:notice] = 'Email o password inválida'
      render action: :new
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Signed out successfuly.'
  end
end
