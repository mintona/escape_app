class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.bigint :uid
      t.string :first_name
      t.string :last_name
      t.string :image
      t.string :google_token
      t.string :email

      t.timestamps
    end
  end
end
