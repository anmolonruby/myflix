class AddReviewsTable < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :video_id
      t.integer :user_id
      t.text :description
      t.integer :rating
      t.timestamps
    end
  end
end
