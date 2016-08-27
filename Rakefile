
task default: 'all_tests'

desc 'Run all tests'
task all_tests: [
  :foodcritic, :chefspec
]

# foodcritic chef lint
require 'foodcritic'
FoodCritic::Rake::LintTask.new

# chefspec unit tests
require 'rspec/core/rake_task'
require 'chef/cookbook/metadata'

# read in metadata
cookbook = Chef::Cookbook::Metadata.new
cookbook.instance_eval(File.read('metadata.rb'))
tasks = []

namespace :chefspec do
  Dir["spec/**/*_spec.rb"].each do |spec_file|
    recipe = spec_file.split('/').last.sub('_spec.rb', '')

    desc "chefspec #{cookbook.name}::#{recipe}"
    RSpec::Core::RakeTask.new(recipe.to_sym) do |t|
      t.rspec_opts = "--color --format progress --example \"#{cookbook.name}::#{recipe}\""
    end

    tasks << "chefspec:#{recipe}"
  end
end

desc 'run chefspec for all recipes'
task chefspec: tasks
