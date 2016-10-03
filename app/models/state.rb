class State < ActiveRecord::Base
	has_many :cities
	validates :name, uniqueness: { scope: :country }
  belongs_to :country
end
