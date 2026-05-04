module Api 
  module V1
    module Auth 
      class MesController < ApplicationController
        def show 
          token = request.headers["Authorization"]&.split(" ")&.last
          account = Account.find_by(auth_token: token)
        
          return render json: { error: "Unauthorized" }, status: :unauthorized unless account
        
          render json: account.slice(:id, :email, :first_name, :role)
        end
        
        private 

        def current_account
          token = request.headers["Authorization"]&.split(" ")&.last
          @current_account ||= Account.find_by(auth_token: token)
        end
      end 
    end 
  end 
end 


# const res = await fetch("/api/auth/me")
# const account = await res.json()


# before_action :require_auth!

# def require_auth!
#   render json: { error: "Unauthorized" }, status: :unauthorized unless current_account
# end