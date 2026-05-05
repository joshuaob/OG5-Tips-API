# app/models/lesson.rb
class Lesson < ApplicationRecord
  has_one :audio_file, dependent: :destroy
  belongs_to :topic, optional: true # remove `optional: true` if you enforced null: false
  validates :title, presence: true
  validates :content, presence: true

  def audio_ready?
    audio_file&.status == "ready"
  end
end