class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.datetime :last_updated_at
      t.string :title
      t.string :url
      t.text :description
      t.string :uri
      t.integer :user_id
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
