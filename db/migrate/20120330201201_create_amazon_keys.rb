class CreateAmazonKeys < ActiveRecord::Migration
  def change
    create_table :amazon_keys do |t|
      t.string :key_code, :null => false
      t.integer :user_id
      t.timestamp :assignment_date

      t.timestamps
    end
  end
end
