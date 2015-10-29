module API
  module V1
    module Helpers

	    def warden
	      env['warden']
	    end

	    def authenticated
	      return true if warden.authenticated?
	      params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])
	    end

	    def current_user
	      warden.user || @user
	    end

    end
  end
end
