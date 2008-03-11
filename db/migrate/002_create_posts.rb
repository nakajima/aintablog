class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :permalink
      t.string :header
      t.text :content
      t.string :cite
      t.string :type
      t.integer :user_id
      t.integer :feed_id
      t.string :lang
      t.integer :comment_counter
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
