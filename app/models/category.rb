class Category < ApplicationRecord
	has_many :article_categories
	has_many :articles, through: :article_categories
	validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }

	before_save :down_case

	private
		def down_case
			self.name.downcase!
		end
end
