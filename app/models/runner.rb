class Runner < ApplicationRecord
  belongs_to :category
  belongs_to :club
  has_many :results
end
