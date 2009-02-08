class AddAllowCommentsToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :allow_comments, :boolean, :default => true
    Post.update_all('allow_comments = 1', 'feed_id = 0')
  end

  def self.down
    remove_column :posts, :allow_comments
  end
end
