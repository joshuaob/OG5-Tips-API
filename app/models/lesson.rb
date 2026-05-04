# app/models/lesson.rb
class Lesson < ApplicationRecord
  has_one :audio_file, dependent: :destroy
  validates :title, presence: true
  validates :content, presence: true

  def audio_ready?
    audio_file&.status == "ready"
  end
end