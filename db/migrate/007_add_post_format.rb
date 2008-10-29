class AddPostFormat < ActiveRecord::Migration
  def self.up
    add_column :posts, :format, :string
  end
  def self.down
    remove_column :posts, :format
  end
end
