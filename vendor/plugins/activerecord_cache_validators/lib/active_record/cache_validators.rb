module ActiveRecord
  module CacheValidators
    def last_modified
      first(:order => 'updated_at DESC').try :updated_at
    end
    
    def etag
      last_modified && last_modified.to_i.to_s
    end
  end
  
  Base.extend(CacheValidators)
end
