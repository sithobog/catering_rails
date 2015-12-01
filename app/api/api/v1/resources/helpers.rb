module API
  module V1
    module Helpers

    	def valid?
				request.headers["X-Auth-Token"].present?
			end

	    def warden
	      request.env['warden']
	    end

	    def authenticate_by_token!

	    	if valid?
	        u = User.where(authentication_token: @request.headers["X-Auth-Token"]).first
	        if u.nil? 
	        	error!("This user doesn't exist", 401)
	        else
	        	env['warden'].set_user(u) if current_user != u
	        end
	      else
	      	error!("Authentication_token is incorrect", 401)
	      end
	    end

	    def current_user
	      warden.user || @user
	    end

    end
  end
end
