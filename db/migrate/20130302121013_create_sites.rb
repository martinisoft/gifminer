class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.integer :user_id
      t.string :type
      t.string :name
      t.string :url
      t.string :avatar
      t.boolean :public
      t.boolean :post
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end
