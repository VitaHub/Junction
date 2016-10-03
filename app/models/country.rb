class Country < ActiveRecord::Base
	has_many :states
	validates :name, uniqueness: true
end
