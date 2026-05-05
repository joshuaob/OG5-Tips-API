class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :otp_secret, null: false
      t.string :auth_token
      t.datetime :otp_sent_at
      t.datetime :last_login_at
      t.timestamps
    end

    add_index :accounts, :email, unique: true
    add_index :accounts, :auth_token, unique: true
  end
end
