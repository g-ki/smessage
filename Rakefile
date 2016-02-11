require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :specs do |task|
  task.pattern = Dir['spec/**/*_spec.rb']
end

task :default => ['specs']

namespace :watch do
  task :all do
    system 'bundle exec observr obser_all.rb'
  end

  task :each do
    system 'bundle exec observr obser_each.rb'
  end
end
