# -*- encoding: utf-8 -*-
# stub: strava-ruby-client 3.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "strava-ruby-client".freeze
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 2.5".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Daniel Doubrovkine".freeze]
  s.date = "2025-10-25"
  s.email = "dblock@dblock.org".freeze
  s.executables = ["strava-oauth-token".freeze, "strava-webhooks".freeze]
  s.files = ["bin/strava-oauth-token".freeze, "bin/strava-webhooks".freeze]
  s.homepage = "http://github.com/dblock/strava-ruby-client".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Strava API Ruby client.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<faraday>.freeze, [">= 2.0"])
  s.add_runtime_dependency(%q<faraday-multipart>.freeze, [">= 1.0"])
  s.add_runtime_dependency(%q<hashie>.freeze, [">= 0"])
end
