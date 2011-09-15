require 'spec_helper'

describe EmailToFace::App do
  before :all do
    @app = EmailToFace::App.new(
      :facebook_user_token  => ENV['FB_USER_TOKEN'],
      :face_api_key         => ENV['FACE_API_KEY'],
      :face_api_secret      => ENV['FACE_API_SECRET'])
  end

  describe "#convert" do

    it "should raise an error if email is nil or malformed" do
      expect { @app.convert(nil) } .to raise_error(ArgumentError)
      expect { @app.convert('@email.com') } .to raise_error(ArgumentError)
      expect { @app.convert('good@email.com') } .to_not raise_error(ArgumentError)
    end

    context 'for facebook' do
      it "should return an object with a url and center x,y if valid" do
        result = @app.convert("pat2man@gmail.com")
        result[:url].should == 'https://graph.facebook.com/518026574/picture?type=large'
        result[:x].should == 48.89
        result[:y].should == 42.29
      end

      it "should return a :facebook_image_type facebook image if :facebook_image_type is set" do
        @app = EmailToFace::App.new(
          :facebook_user_token  => ENV['FB_USER_TOKEN'],
          :facebook_image_type  => 'small')

        result = @app.convert("pat2man@gmail.com")
        result[:url].should == 'https://graph.facebook.com/518026574/picture?type=small'
      end
    end

    context 'for gravatar' do
      it "should return an object with a url and center x,y if valid and :use_face_for_gravatar set" do
         @app = EmailToFace::App.new(
            :use_face_for_gravatar  => true,
            :facebook_user_token    => ENV['FB_USER_TOKEN'],
            :face_api_key           => ENV['FACE_API_KEY'],
            :face_api_secret        => ENV['FACE_API_SECRET'])
        result = @app.convert("virulent@gmail.com")
        result[:url].should == 'http://www.gravatar.com/avatar.php?gravatar_id=c44b0f24cfce9aacc7c1969c5666cfae&d=404&s=180'
        result[:x].should == 31.39
        result[:y].should == 60.28
      end

      it "should return an object with a url if :use_face_for_gravatar not set" do
         @app = EmailToFace::App.new(
            :face_api_key           => ENV['FACE_API_KEY'],
            :face_api_secret        => ENV['FACE_API_SECRET'])
        result = @app.convert("virulent@gmail.com")
        result[:url].should == 'http://www.gravatar.com/avatar.php?gravatar_id=c44b0f24cfce9aacc7c1969c5666cfae&d=404&s=180'
        result[:x].should be_nil
        result[:y].should be_nil
      end
    end

  end

end