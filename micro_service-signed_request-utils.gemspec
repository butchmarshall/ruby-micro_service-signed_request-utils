# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'micro_service/signed_request/utils/version'

Gem::Specification.new do |spec|
	spec.name          = "micro_service-signed_request-utils"
	spec.version       = MicroService::SignedRequest::Utils::VERSION
	spec.authors       = ["Butch Marshall"]
	spec.email         = ["butch.a.marshall@gmail.com"]
	
	spec.summary       = "Utility functions for handling signed requests in the Microservice gem"
	spec.description   = "Utility functions for handling signed requests in the Microservice gem"
	spec.homepage      = "https://github.com/butchmarshall/ruby-microservice-signed_request-utils"
	spec.license       = "MIT"

	spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
	spec.bindir        = "exe"
	spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]

	spec.add_dependency "cgi-query_string", "~> 0.1.0"

	spec.add_development_dependency "bundler", ">= 1"
	spec.add_development_dependency "rake", "~> 10.0"
	spec.add_development_dependency "rspec"
end
