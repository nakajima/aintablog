class AddDeletedAtToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :deleted_at, :datetime
  end

  def self.down
    remove_column :posts, :deleted_at
  end
end
