# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'barbatos/version'

Gem::Specification.new do |spec|
  spec.name          = 'barbatos'
  spec.version       = Barbatos::VERSION
  spec.authors       = ['okazu-dm']
  spec.email         = ['uhavetwocows@gmail.com']

  spec.summary       = 'Sample WAF Code'
  spec.description   = 'Just study of Web Application Framework (not suitable for use)'
  spec.homepage      = 'https://github.com/okazu-dm/barbatos'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split('\x0').reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'tilt', '~> 1.4'
end
