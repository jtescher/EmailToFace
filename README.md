EmailToFace
====

Installation
---

Easy:

	[sudo|rvm] gem install email_to_face

Using Bundler:

	gem "email_to_face"

Facebok Graph API
----

The Graph API is the simple, slick new interface to Facebook's data.  Using it to get a user image with EmailToFace is quite straightforward.
See [developers.facebook.com/docs/authentication/](https://developers.facebook.com/docs/authentication/) for more information on obtaining access tokens.

``` ruby
@email_to_face = EmailToFace::App.new(:facebook_user_token => oauth_access_token)
@email_to_face.convert('user@email.com')
=> { :url => 'https://graph.facebook.com/111111111/picture?type=large' }
```


Gravatar
----

If the user is not found via the Facebook Graph API, or if an access token is not passed, the Gravatar API will be called.

``` ruby
@email_to_face = EmailToFace::App.new()
@email_to_face.convert('user@email.com')
=> { :url => 'http://www.gravatar.com/avatar.php?gravatar_id=c44b0f24cfce9aacc7c1969c5666cfae&d=404' }
```

Face.com
----

If face.com credentials are passed, the convert method will return the location of the users's face in the image.
See [developers.face.com](http://developers.face.com/) for more information.

``` ruby
@email_to_face = EmailToFace::App.new(
	:facebook_user_token => oauth_access_token,
	:face_api_key 		 => key,
	:face_api_secret 	 => secret)

@email_to_face.convert('user@email.com')
=> { :url => 'https://graph.facebook.com/111111111/picture?type=large', :x => 48.89, :y => 38.1 }
```


Optional settings
----

By default Gravatar always returns square centered images. If you want to use face.com to find the center of the face anyway, you can use the `:use_face_for_gravatar` option:

``` ruby
@email_to_face = EmailToFace::App.new(
	:use_face_for_gravatar 	=> true,
	:face_api_key			=> key,
	:face_api_secret		=> secret)

@email_to_face.convert('user@email.com')
=> { :url => 'http://www.gravatar.com/avatar.php?gravatar_id=c44b0f24cfce9aacc7c1969c5666cfae&d=404', :x => 48.89, :y => 38.1 }
```