module EmailToFace
  class App
    attr_accessor :fb_init, :face_init

    def initialize(options={})

      # Initialize Facebook if params present
      if options[:facebook_user_token]
        Facebook.init(options[:facebook_user_token])
        @fb_init = true
      end

      # Initialize Face.com API if params present
      if options[:face_api_key] and options[:face_api_secret]
        FaceAPI.init(options[:face_api_key], options[:face_api_secret])
        @face_init = true
      end
    end

    def convert(email)
      raise ArgumentError, "must pass a valid email address" if email.nil? or !email.match(/^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i)

      # First query facebook if initialized
      if @fb_init
        image_url = Facebook.user_image(email)
      end

      # If not found and twitter is initialized
      if image_url.nil?
        image_url = Gravatar.user_image(email)
      end

      # If still no image found, return nil
      return nil if image_url.nil?

      # If present, grab face x,y from face.com
      if @face_init
        xy = FaceAPI.get_center(image_url)
        { :url => image_url, :x => xy['x'], :y => xy['y'] }
      else
        { :url => image_url }
      end
    end
  end
end