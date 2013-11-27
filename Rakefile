require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task 'spinach' do
  sh 'spinach'
end

task default: [:spec, :spinach]
