require 'rake/extensiontask'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

gemspec = Gem::Specification.load('lowess.gemspec')
Rake::ExtensionTask.new('ext_lowess')

Gem::PackageTask.new(gemspec) do |pkg|
end

task default: [ :compile, :test ]
