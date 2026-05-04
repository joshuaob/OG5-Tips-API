module TextToSpeech
  class Creator
    def initialize(lesson:, provider: :elevenlabs)
      @lesson = lesson
      @provider = provider
      @uploader = Storage::S3Uploader.new
    end

    # old audio → new audio ready → swap → old removed
    def call
      digest = Digest::SHA256.hexdigest(@lesson.content)
      existing = @lesson.audio_file

      if existing&.content_hash == digest && existing.ready?
        return existing
      end

      audio_binary = client.synthesize(
        text: @lesson.content
      )

      key = "lessons/#{@lesson.id}/#{SecureRandom.uuid}.mp3"

      @uploader.upload(
        io: StringIO.new(audio_binary),
        key: key
      ) 

      ActiveRecord::Base.transaction do
        # 🧹 clean old AFTER success
        if existing&.s3_key.present?
          @uploader.delete(key: existing.s3_key)
          existing.destroy!
        end

        # 🆕 create new record
        @lesson.create_audio_file!(
          provider: @provider,
          status: :ready,
          s3_key: key,
          content_hash: digest
        )
      end 

    rescue => e
      # audio_file.update!(status: "failed")
      raise e
    end

    private

    def client
      case @provider
      when :elevenlabs
        TextToSpeech::ElevenLabsClient.new
      when :awspolly 
        TextToSpeech::AwsPollyClient.new 
      end
    end
  end
end