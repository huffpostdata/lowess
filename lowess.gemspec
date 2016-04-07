$:.push File.expand_path('../lib', __FILE__)
require 'lowess/version'

Gem::Specification.new do |s|
  s.name = 'lowess'
  s.version = Lowess::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = [ 'Adam Hooper' ]
  s.email = [ 'adam@adamhooper.com' ]
  s.homepage = 'http://rubygems.org/gems/ruby-lowess'
  s.summary = 'Lowess scatter plot smoothing'
  s.description = 'Runs the Lowess smoothing algorithm'
  s.license = 'GPL2'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")

  s.require_paths = [ 'lib' ]
  s.extensions = FileList['ext/ext_lowess/extconf.rb']

  s.add_development_dependency 'rake', '~> 11'
  s.add_development_dependency 'rake-compiler', '~> 0.9'
end
