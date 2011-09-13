require 'spec_helper'

describe EmailToFace::Facebook do
  before :each do
    @app = EmailToFace::App.new(
      :facebook_user_token      => ENV['FB_USER_TOKEN'],
      :face_api_key             => ENV['FACE_API_KEY'],
      :face_api_secret          => ENV['FACE_API_SECRET'])
  end

  describe ".user_image" do
    it "returns the url for the Facebook user's image if it exists" do
      EmailToFace::Facebook.user_image('pat2man@gmail.com').should == 'https://graph.facebook.com/518026574/picture?type=large'
    end

    it "returns nil if the user does not exist" do
      EmailToFace::Facebook.user_image('notanemail').should be_nil
    end
  end
end

describe EmailToFace::Gravatar do
  describe ".user_image" do
    it "returns the url for the user's image if it exists" do
      EmailToFace::Gravatar.user_image('virulent@gmail.com').should == 'http://www.gravatar.com/avatar.php?gravatar_id=c44b0f24cfce9aacc7c1969c5666cfae&d=404'
    end

    it "returns nil if the user does not exist" do
      EmailToFace::Gravatar.user_image('notanemail').should be_nil
    end
  end
end

describe EmailToFace::FaceAPI do
  before :each do
    @app = EmailToFace::App.new(
      :facebook_user_token      => ENV['FB_USER_TOKEN'],
      :face_api_key             => ENV['FACE_API_KEY'],
      :face_api_secret          => ENV['FACE_API_SECRET'])
  end

  describe ".get_center" do
    it "returns the proper face.com response" do
      result = EmailToFace::FaceAPI.get_center('https://graph.facebook.com/10736346/picture?type=large')
      result.should == {"x"=>48.89, "y"=>38.1}
    end
  end

end