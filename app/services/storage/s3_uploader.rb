# app/services/storage/s3_uploader.rb
require "aws-sdk-s3"

module Storage 
  class S3Uploader
    def initialize
      @client = Aws::S3::Resource.new(region: ENV["AWS_REGION"])
      @bucket = @client.bucket(ENV["S3_BUCKET"])
    end
  
    def upload(io:, key:, content_type: "audio/mpeg")
      obj = @bucket.object(key)
  
      obj.put(
        body: io,
        content_type: content_type
      )
  
      key
    end

    def presigned_url(key:, expires_in: 3600)
      signer = Aws::S3::Presigner.new
    
      signer.presigned_url(
        :get_object,
        bucket: ENV["S3_BUCKET"],
        key: key,
        expires_in: expires_in
      )
    end 

    def delete(key:)
      obj = @bucket.object(key)
      obj.delete
    end
  end
end 