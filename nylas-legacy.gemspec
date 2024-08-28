# frozen_string_literal: true

require "./gem_config"

Gem::Specification.new do |gem|
  GemConfig.apply(gem, "nylas-legacy")
  gem.summary = %(Gem for interacting with the Nylas API)
  gem.description = %(Gem for interacting with the Nylas API.)
  gem.add_runtime_dependency "rest-client", ">= 1.6", "< 3.0"
end
