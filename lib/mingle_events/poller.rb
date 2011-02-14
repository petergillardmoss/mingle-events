module MingleEvents
  class Poller
    
    # Manages a full sweep of event processing across each processing pipeline
    # configured for specified mingle projects. processors_by_project_identifier should
    # be a hash where the keys are mingle project identifiers and the values are
    # lists of event processors.
    def initialize(mingle_access, processors_by_project_identifier, state_folder)
      @mingle_access = mingle_access
      @state_folder = state_folder
      @processors_by_project_identifier = processors_by_project_identifier
    end

    # Run a single poll for each project configured with processor(s) and 
    # broadcast each event to each processor.
    def run_once  
      puts "About to poll Mingle for new events..."
      @processors_by_project_identifier.each do |project_identifier, processors|
        begin                  
          project_feed = ProjectFeed.new(project_identifier, @mingle_access)
          pump = ProjectEventBroadcaster.new(project_feed, processors, state_file(project_identifier))
          pump.process_new_events        
        rescue StandardError => e
          puts "\nUnable to retrieve events for project '#{project_identifier}':"
          puts e
          puts "Trace:\n"
          puts e.backtrace
        end
      end
    end
    
    private
    
    def state_file(project_identifier)
      File.join(@state_folder, "#{project_identifier}_state.yml")
    end

  end
end