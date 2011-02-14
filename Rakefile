require 'rake'
require 'rake/testtask'

require 'lib/mingle_events'

task :default => [:test, :clean]

desc "Run tests"
Rake::TestTask.new do |task|
  task.pattern = 'test/**/*_test.rb'
  task.verbose = true
  task.warning = true
end

task :clean do
  FileUtils.rm_rf('test/tmp')
end

task :poll_once_example do
  
  state_folder = File.join(File.dirname(__FILE__), 'example_app_state') 
  FileUtils.rm_rf(state_folder) if ENV['CLEAN'] == 'true '
  
  mingle_access = MingleEvents::MingleBasicAuthAccess.new(
    'https://mingle.example.com:7071',
    ENV['MINGLE_USER'],
    ENV['MINGLE_PASSWORD']
  )
    
  card_data = MingleEvents::Processors::CardData.new(mingle_access, 'test_project')
      
  log_commenting_on_bugs_and_stories = MingleEvents::Processors::Pipeline.new([
      card_data,
      MingleEvents::Processors::CardTypeFilter.new(['story', 'bug'], card_data),
      MingleEvents::Processors::CategoryFilter.new([MingleEvents::Category::COMMENT_ADDITION]),
      MingleEvents::Processors::PutsPublisher.new
    ])
    
  processors_by_project = {
    'test_project' => [log_commenting_on_bugs_and_stories]
  }
    
  MingleEvents::Poller.new(mingle_access, processors_by_project, state_folder).run_once  
end