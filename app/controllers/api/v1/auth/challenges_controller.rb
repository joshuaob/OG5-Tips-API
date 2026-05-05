module Api 
  module V1 
    module Auth 
      class ChallengesController < ApplicationController
        def create 
          account = Account.find_or_initialize_by(email: challenge_params[:email])
          account.first_name = challenge_params[:first_name]
          account.save!
          
          unless account.can_send_otp?
            return render json: { error: "Too many requests" }, status: :too_many_requests
          end

          code = account.generate_otp
          OtpMailer.send_otp(account:, code:).deliver_now
          render json: { success: true }

        rescue ActiveRecord::RecordInvalid => e
          render json: { error: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end

        def verify 
          account = Account.find_by(email: params[:email])
          return render json: { error: "Invalid email" }, status: :unauthorized unless account
        
          token = account.verify_otp!(params[:code])

          if token
            render json: { auth_token: token }
          else
            render json: { error: "Invalid code" }, status: :unauthorized
          end
        end 
        
        private

        def challenge_params
          params.require(:challenge).permit(:email, :first_name)
        end
      end 
    end 
  end 
end 