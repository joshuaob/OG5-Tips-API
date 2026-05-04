module TextToSpeech
  class ElevenLabsClient
    def synthesize(text:)
      api_key = ENV['ELEVENLABS_API_KEY']
      voice_id = ENV['ELEVENLABS_VOICE_ID']
      uri = URI("https://api.elevenlabs.io/v1/text-to-speech/#{voice_id}?output_format=mp3_44100_128")

      req = Net::HTTP::Post.new(uri)
      req["xi-api-key"] = api_key
      req["Content-Type"] = "application/json"
      req.body = {
        text: text,
        model_id: "eleven_multilingual_v2"
      }.to_json

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      raise "TTS failed" unless res.is_a?(Net::HTTPSuccess)

      res.body # ← raw MP3 binary
    end
  end
end