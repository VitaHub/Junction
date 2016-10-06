class UserController < ApplicationController
	before_action :authenticate_user!
	PER_PAGE = 20

	def index
		@users = User.all.order('created_at DESC').paginate(page: params[:page], per_page: PER_PAGE)
		if search_params_available?(params)
	    @users = @users.by_name(params[:search]) if params[:search].to_s.size > 2
	    @users = @users.by_gender(params[:gender]) unless params[:gender].to_s.empty?
	    @users = @users.by_min_age(params[:min_age]) unless params[:min_age].to_s.empty?
	    @users = @users.by_max_age(params[:max_age]) unless params[:max_age].to_s.empty?
	    unless params[:country_id].to_s.empty?
	    	unless params[:state_id].to_s.empty?
	    		unless params[:city_id].to_s.empty?
	    			@users = @users.by_city(params[:city_id])
	    		else
	    			@users = @users.by_state(params[:state_id])
	    		end
	    	else
	    		@users = @users.by_country(params[:country_id])
	    	end
	    end
	    @users.paginate(page: params[:page], per_page: PER_PAGE)
	  else
	    @users = User.all.order('created_at DESC').paginate(page: params[:page], per_page: PER_PAGE)
		end

		respond_to do |format|
			format.html
			format.js
		end
	end

	def show
		@user = User.find(params[:id])
	end

		private

	def search_params_available?(params)
		if !params[:gender].to_s.empty? ||
			!params[:min_age].to_s.empty? || 
			!params[:max_age].to_s.empty? ||
			!params[:country_id].to_s.empty?
			return true
		end
		if params[:search]
			return true if params[:search].to_s.size > 2
		end
	end
	
end
