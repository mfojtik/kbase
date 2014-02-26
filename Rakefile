require 'bundler/setup'
require 'padrino-core/cli/rake'

PadrinoTasks.use(:database)
PadrinoTasks.use(:sequel)
PadrinoTasks.init

desc "Prepare test database"
task 'prepare:test' do
  ENV['RACK_ENV'] = 'test'
  FileUtils.rm_f(TEST_DATABASE_PATH, :verbose => true)
  Rake::Task['sq:migrate'].invoke
end
