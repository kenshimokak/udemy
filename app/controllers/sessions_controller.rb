class SessionsController < ApplicationController
	def new
		
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			session[:user_id] = user.id
			flash.now[:notice] = "You logged successfully"
			redirect_to user_path(user)
		else
			flash.now[:notice] = "You email or password is incorrect"
			render 'new'
		end
	end

	def destroy
		session[:user_id] = nil
		flash.now[:notice] = "You have logged out"
		redirect_to login_path
	end

end