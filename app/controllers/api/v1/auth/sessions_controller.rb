module Api 
  module V1 
    module Auth 
      class SessionsController < ApplicationController
        def destroy
          token = request.headers["Authorization"]&.split(" ")&.last
          account = Account.find_by(auth_token: token)

          if account
            account.update!(auth_token: nil)
          end

          head :no_content
        end
      end 
    end 
  end 
end 