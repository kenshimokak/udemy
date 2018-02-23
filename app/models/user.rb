class User < ApplicationRecord
	has_many :articles, dependent: :destroy
	has_many :comments

	has_many :friendships
 	has_many :friends, through: :friendships
	
	before_save :dowancase_fields

	validates :full_name, presence: true

	validates :username, presence: true,
			  uniqueness: { case_sensitive: false },
			  length: { minimum: 4, maximum: 25 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 105 },
			  uniqueness: { case_sensitive: false },
			  format: { with: VALID_EMAIL_REGEX }

    has_secure_password 

  def self.search(param)
    param.strip!
    param.downcase!
    to_send_back = (name_matches(param) + email_matches(param)).uniq
    return nil unless to_send_back
    to_send_back
  end
  
  def self.name_matches(param)
    matches('full_name', param)
  end
   
  def self.email_matches(param)
    matches('email', param)
  end
  
  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%").where("admin='f'")
  end

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  def not_friends_with?(friend_id)
    friendships.where(friend_id: friend_id).count < 1
  end
  
  private 
	def dowancase_fields
		self.username.downcase!
		self.email.downcase!
	end
end
