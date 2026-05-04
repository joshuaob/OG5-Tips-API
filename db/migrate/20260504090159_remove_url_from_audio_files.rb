class RemoveUrlFromAudioFiles < ActiveRecord::Migration[8.0]
  def change
    remove_column :audio_files, :url
  end
end
