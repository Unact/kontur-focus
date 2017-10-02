# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kontur_focus/version"

Gem::Specification.new do |spec|
  spec.name          = "kontur-focus"
  spec.version       = KonturFocus::VERSION
  spec.authors       = ["unact"]
  spec.summary       = "Kontur.Focus integration"
  spec.description   = "Kontur.Focus integration"
  spec.homepage      = "https://github.com/Unact/kontur-focus"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Не получается использовать 3-ю версию гема ("~> 3.0.0.pre")
  # из-за баги при тестировании post запроса
  spec.add_dependency "http", "~> 2"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end
