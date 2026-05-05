class Topic < ApplicationRecord
  # after destroy clear s3 audio files
  has_many :lessons, dependent: :nullify # or :destroy if you want cascading deletes
  validates :title, presence: true
end
