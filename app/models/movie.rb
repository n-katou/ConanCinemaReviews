class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :votes, dependent: :destroy 
end
