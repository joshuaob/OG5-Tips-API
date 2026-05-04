# app/models/audio_file.rb
class AudioFile < ApplicationRecord
  belongs_to :lesson
  
  enum :status, {
    pending: 0,
    processing: 1,
    ready: 2,
    failed: 3
  }, default: :pending

  enum :provider, {
    elevenlabs: 0,
    awspolly: 1
  }, default: :elevenlabs

  validates :status, presence: true
  validates :provider, presence: true

  def presigned_url
    Storage::S3Uploader.new.presigned_url(key: s3_key)
  end 
end