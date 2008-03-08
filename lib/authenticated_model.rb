%w(rubygems active_record digest/sha1).each { |lib| require lib }
module AuthenticatedModel

  def self.included(base)
    base.extend(AccessMethod)
  end
  
  module AccessMethod
    def authenticated_model
      self.extend(ClassMethods)
      self.send :include, InstanceMethods
      
      # Virtual attribute for the unencrypted password
      attr_accessor :password

      validates_presence_of     :email
      validates_presence_of     :password,                   :if => :password_required?
      validates_presence_of     :password_confirmation,      :if => :password_required?
      validates_length_of       :password, :within => 4..40, :if => :password_required?
      validates_confirmation_of :password,                   :if => :password_required?
      validates_length_of       :email,    :within => 3..100
      validates_uniqueness_of   :email, :case_sensitive => false
      before_save :encrypt_password

      # prevents a user from submitting a crafted form that bypasses activation
      # anything else you want your user to change should be added here.
      attr_accessible :email, :password, :password_confirmation
      
    end
  end  
  
  module ClassMethods
    # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
    def authenticate(email, password)
      u = find_by_email(email) # need to get the salt
      u && u.authenticated?(password) ? u : nil
    end

    # Encrypts some data with the salt.
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end
  end
  
  module InstanceMethods
    # Encrypts the password with the user salt
    def encrypt(password)
      self.class.encrypt(password, salt)
    end

    def authenticated?(password)
      crypted_password == encrypt(password)
    end

    def remember_token?
      remember_token_expires_at && Time.now.utc < remember_token_expires_at 
    end

    # These create and unset the fields required for remembering users between browser closes
    def remember_me
      remember_me_for 2.weeks
    end

    def remember_me_for(time)
      remember_me_until time.from_now.utc
    end

    def remember_me_until(time)
      self.remember_token_expires_at = time
      self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
      save(false)
    end

    def forget_me
      self.remember_token_expires_at = nil
      self.remember_token            = nil
      save(false)
    end

    protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end
  end
  
end

ActiveRecord::Base.send :include, AuthenticatedModel