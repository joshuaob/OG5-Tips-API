class CreateAudioFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :audio_files do |t|
      t.references :lesson, null: false, foreign_key: true
      t.integer :provider, null: false, default: 0 
      t.string :s3_key
      t.string :url
      t.integer :duration
      t.integer :status, default: 0, null: false
      t.string :content_hash
      t.timestamps
    end

    add_index :audio_files, :content_hash
  end
end
