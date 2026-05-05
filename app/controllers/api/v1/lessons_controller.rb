module Api
  module V1
    class LessonsController < ApplicationController
      before_action :authenticate_account!

      def index 
        topics = Topic.includes(:lessons)

        result = topics.map do |topic|
          {
            name: topic.title,
            description: topic.description,
            lessons: topic.lessons.map do |lesson|
              {
                id: lesson.id, 
                title: lesson.title,
                topic: topic.title,
                duration: "12 minutes",
                durationSec: "12 sec",
                blurb: lesson.title 
              }
            end
          }
        end
      
        render json: result
      end
      
      def show 
        # binding.pry 
        lesson = Lesson.includes(:topic).find(params[:id])

        render json: map_lesson(lesson)
      end 

      def create
        lesson = Lesson.new(lesson_params)

        if lesson.save
          tts = TextToSpeech::Creator.new(lesson: lesson, provider: :elevenlabs)
          tts.call 
          render json: lesson, status: :created
        else
          render json: { errors: lesson.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def lesson_params
        params.require(:lesson).permit(:topic_id, :title, :content)
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

      def map_lesson(lesson)
        {
          id: lesson.id,
          title: lesson.title,
          topic: lesson.topic&.title,
          url: lesson.audio_file.presigned_url,
          content: lesson.content
        }
      end
    end
  end
end