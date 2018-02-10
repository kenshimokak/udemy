class User < ApplicationRecord
	has_many :comments

	before_save :dowancase_fields

	validates :username, presence: true,
			  uniqueness: { case_sensitive: false },
			  length: { minimum: 4, maximum: 25 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 105 },
			  uniqueness: { case_sensitive: false },
			  format: { with: VALID_EMAIL_REGEX }

	private 
		def dowancase_fields
			self.username.downcase!
		end

end