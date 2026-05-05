class AddTopicToLessons < ActiveRecord::Migration[8.0]
  def change
    add_reference :lessons, :topic, null: false, foreign_key: true
  end
end
