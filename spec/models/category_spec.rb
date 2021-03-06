require 'spec_helper'

describe Category do
  it { should have_many(:videos)}
  it { should validate_presence_of(:name)}

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:invitation) }
  end

  describe "recent videos" do
    
    it "returns an empty array of videos if there are no videos in the category" do
      drama = Category.create(name: 'Drama')      
      expect(drama.recent_videos).to eq([])
    end

    it "returns an array of one video if there is only one in the category" do
      comedy = Category.create(name: 'Comedy')
      
      Video.create(title: "foo", description: "bar")
      
      Video.find_each do | video |
        VideoCategory.create(video_id: video.id, category_id: comedy.id)
      end

      expect(comedy.recent_videos.count).to eq(1)
      
    end

    it "returns an array of n videos" do
      comedy = Category.create(name: 'Comedy')
      
      2.times {Video.create(title: "foo", description: "bar")}
      
      Video.all.each do | video |
        VideoCategory.create(video_id: video.id, category_id: comedy.id)
      end

      expect(comedy.recent_videos.count).to eq(2)
      
    end

    it "returns videos in descending order" do
      comedy = Category.create(name: 'Comedy')

      happy_gilmore = Video.create(title: 'Happy Gilmore', description: 'A rejected hockey player puts his skills to the golf course to save his grandmother\'s house.', created_at: 2.day.ago)
      futurama = Video.create(title: 'Futurama', description: 'Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year\'s Eve 2999.', created_at: 3.days.ago)
      simpsons = Video.create(title: 'The Simpsons', description: 'The satiric adventures of a working-class family in the misfit city of Springfield.', created_at: 1.days.ago)
      psych = Video.create(title: 'Psych', description: 'A novice sleuth is hired by the police after he cons them into thinking he has psychic powers that help solve crimes.', created_at: 11.days.ago)
      monk = Video.create(title: 'Monk', description: 'Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.', created_at: 4.days.ago)
      family_guy = Video.create(title: 'Family Guy', description: 'In a wacky Rhode Island town, a dysfunctional family strive to cope with everyday life as they are thrown from one crazy scenario to another.', created_at: 2.days.ago)
      
      VideoCategory.create(video_id: happy_gilmore.id, category_id: comedy.id)
      VideoCategory.create(video_id: futurama.id, category_id: comedy.id)
      VideoCategory.create(video_id: simpsons.id, category_id: comedy.id)
      VideoCategory.create(video_id: psych.id, category_id: comedy.id)
      VideoCategory.create(video_id: monk.id, category_id: comedy.id)
      VideoCategory.create(video_id: family_guy.id, category_id: comedy.id)

      expect(comedy.recent_videos).to eq([simpsons, family_guy, happy_gilmore, futurama, monk, psych])
    end

    it "returns an array of only six videos if there are more than six in the category" do
      comedy = Category.create(name: 'Comedy')
      
      7.times {Video.create(title: "foo", description: "bar")}

      Video.all.each do | video |
        VideoCategory.create(video_id: video.id, category_id: comedy.id)
      end

      expect(comedy.recent_videos.count).to eq(6)
      
    end

  end
end
