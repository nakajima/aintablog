require File.join(File.dirname(__FILE__), *%w[test_helper])

describe ActiveRecord::CacheValidators do
  before do
    build_model(:articles) do
      string :title
      timestamps
    end
  end
  
  describe "last_modified" do
    describe "when there are records" do
      before do
        @first_modified = Article.create!(:title => "The first", :updated_at => 1.day.ago)
        @last_modified = Article.create!(:title => "The last")
      end
      
      it "returns last modified record" do
        Article.last_modified.to_s.should == @last_modified.updated_at.to_s
      end
    end
    
    describe "when there are no records" do
      it "returns nil" do
        Article.last_modified.should.be.nil
      end      
    end
  end
  
  describe "etag" do
    describe "when there are records" do
      before do
        @first_modified = Article.create!(:title => "The first", :updated_at => 1.day.ago)
        @last_modified = Article.create!(:title => "The last")
      end
      
      it "returns updated_at to_i of last_modified" do
        Article.etag.should == @last_modified.updated_at.to_i.to_s
      end
    end
    
    describe "when there are no records" do
      it "returns nil" do
        Article.etag.should.be.nil
      end
    end
  end
end
