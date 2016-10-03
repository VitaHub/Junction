class City < ActiveRecord::Base
	validates :name, uniqueness: { scope: :state }
  belongs_to :state
end
