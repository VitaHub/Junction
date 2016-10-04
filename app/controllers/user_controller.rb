class UserController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@users = User.all.order('created_at DESC')
		if params[:search]
			if params[:search].size > 2
		    @users = User.search(params[:search]).order("created_at DESC")
			end
	  else
	    @users = User.all.order('created_at DESC')
		end

		respond_to do |format|
			format.html
			format.js
		end
	end

	def show
		@user = User.find(params[:id])
	end
end
