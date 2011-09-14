# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "email_to_face/version"

Gem::Specification.new do |s|
  s.name        = "email_to_face"
  s.version     = EmailToFace::VERSION
  s.authors     = ["Julian Tescher"]
  s.email       = ["jatescher@gmail.com"]
  s.homepage    = "https://github.com/jtescher/EmailToFace"
  s.summary     = %q{ Email to user image tool }
  s.description = %q{ A way to simply obtain a facebook, or gravatar image from an email. }

  s.rubyforge_project = "email_to_face"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"

  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "face"
end
