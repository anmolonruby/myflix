class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates :rating, presence: true
  validates :description, presence: true
end
