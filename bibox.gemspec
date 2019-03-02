
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bibox/version"

Gem::Specification.new do |spec|
  spec.name          = "bibox"
  spec.version       = Bibox::VERSION
  spec.authors       = ["Sebastian Johnsson"]
  spec.email         = ["sebastian.johnsson@gmail.com"]

  spec.summary       = %q{Ruby REST + Websocket clients for Bibox's API'}
  spec.description   = %q{Ruby REST + Websocket clients for crypto currency exchange Bibox's API}
  spec.homepage      = "https://github.com/SebastianJ/bibox"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday",                ">= 0.15.4"
  spec.add_dependency "faraday_middleware",     ">= 0.13.1"
  
  spec.add_dependency "faye-websocket", ">= 0.10.7"
  spec.add_dependency "eventmachine", ">= 1.2.7"
  
  spec.add_development_dependency "bundler",    "~> 1.16"
  spec.add_development_dependency "rake",       "~> 10.0"
  spec.add_development_dependency "rspec",      "~> 3.0"
  spec.add_development_dependency "rdoc",       "~> 6.0"
  spec.add_development_dependency "vcr",        "~> 4.0"
  spec.add_development_dependency "webmock",    "~> 3.1"
  
  spec.add_development_dependency "pry",        "~> 0.12.2"
end
