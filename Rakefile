require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :specs do |task|
  task.pattern = Dir['spec/**/*_spec.rb']
end

task :default => ['specs']

task :watch_all do
  system 'bundle exec observr obser_all.rb'
end

task :watch_each do
  system 'bundle exec observr obser_each.rb'
end
