require "json"
require 'net/http'
require 'face'
require "email_to_face/version"
require 'email_to_face/app'

module EmailToFace
  class Facebook

    def self.init(fb_access_token, facebook_image_type)
      @access_token = fb_access_token
      @image_type = facebook_image_type
    end

    def self.user_image(email)
      begin
        # Query the graph for the user e.g. email@gmail.com&type=user&access_token=token
        url = URI.encode("https://graph.facebook.com/search?q=#{email}&type=user&access_token=#{@access_token}")
        uri = URI.parse(url)

        req = Net::HTTP.new(uri.host, 443)
        req.use_ssl = true

        response = req.request_get(uri.path + '?' + uri.query)
        result = JSON.parse(response.body)
      rescue Exception => e
        puts e.inspect
        return nil
      end

      # Raise error if one is returned
      raise result["error"]["message"] if result["error"]

      # Return either the url, or nil
      result['data'] == [] ? nil : "https://graph.facebook.com/#{result['data'][0]['id']}/picture?type=#{@image_type || 'large'}"
    end

  end

  class Gravatar

    def self.user_image(email, fb_type=nil)
      fb_types = { 'square' => 50, 'small' => 50, 'normal' => 100, 'large' => 180 }
      begin
        url = "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5::hexdigest(email)}&d=404&s=#{fb_types[fb_type] || 180}"
        response = Net::HTTP.get_response(URI.parse(url))
        response.code == '200' ? url : nil
      rescue Exception => e
        puts e.inspect
        return nil
      end
    end

  end

  class FaceAPI

    def self.init(face_api_key, face_api_secret, use_face_for_gravatar)
      @client = Face.get_client(:api_key => face_api_key, :api_secret => face_api_secret)
      @use_face_for_gravatar = use_face_for_gravatar || false
    end

    def self.get_center(url)
      return if url.match(/gravatar.com/) and @use_face_for_gravatar == false
      begin
        result = @client.faces_detect(:urls => url)
        result['photos'][0]['tags'].empty? ? nil : result['photos'][0]['tags'][0]['center']
      rescue Exception => e
        puts e.inspect
        return nil
      end
    end

  end
end
