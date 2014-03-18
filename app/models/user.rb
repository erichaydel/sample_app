class User < ActiveRecord::Base

	has_secure_password
	has_many :microposts, dependent: :destroy
	has_many :relationships, 					foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, 				through: :relationships, source: :followed
	has_many :reverse_relationships, 	foreign_key: "followed_id", 
																		class_name: "Relationship",
																		dependent: :destroy
	has_many :followers, 							through: :reverse_relationships, source: :follower
	
	before_save  { self.email = email.downcase }
	before_create :create_remember_token 

	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-\+.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
																uniqueness: { case_sensitive: false }
	
	validates :password, presence: true, length: { minimum: 6 }
	validates :password_confirmation, presence: true
	
	
	
	def following?(other_user)
		self.relationships.find_by(followed_id: other_user.id)
	end
	
	def follow!(other_user)
		self.relationships.create!(followed_id: other_user.id)
	end
	
	def unfollow!(other_user)
		self.relationships.find_by(followed_id: other_user.id).destroy
	end
	
	
	def feed
		# This is not the final implementation
		Micropost.from_users_followed_by(self)
	end
	
	
	def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end

end
