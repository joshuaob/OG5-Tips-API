require "aws-sdk-polly"

module TextToSpeech
  class AwsPollyClient
    def synthesize(text:)
      voice_id = "Joanna"
      client = Aws::Polly::Client.new(region: ENV["AWS_REGION"])

      resp = client.synthesize_speech(
        text: text,
        voice_id: voice_id,
        output_format: "mp3"
      )

      resp.audio_stream.read
    end
  end
end