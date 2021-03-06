class Video < ActiveRecord::Base
  has_many :video_categories
  has_many :categories, through: :video_categories
  has_many :reviews, -> { order("created_at DESC") }

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description

  def self.search_by_title(query)
    return [] if query.blank?
    where("title ILIKE ?", "%#{query}%").order("created_at DESC")
  end

  def rating
    reviews.any? ? reviews.first.rating : nil
  end
end
