module Api
  module V1
    class TopicsController < ApplicationController
      before_action :authenticate_account!

      def index 
        topics = Topic.all

        render json: topics
      end 

      def create
        topic = Topic.new(topic_params)

        if topic.save
          render json: topic, status: :created
        else
          render json: { errors: topic.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def topic_params
        params.require(:topic).permit(:title, :description)
      end

      def current_account
        return @current_account if defined?(@current_account)
    
        token = request.headers["Authorization"]&.split(" ")&.last
        @current_account = Account.find_by(auth_token: token)
      end
    
      def authenticate_account!
        unless current_account
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end
    end
  end
end