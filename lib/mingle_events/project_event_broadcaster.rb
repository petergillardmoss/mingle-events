module MingleEvents
  
  # For a given project, polls for previously unseen events and broadcasts these events
  # to a list of processors, all interested in the project's events.
  #--
  # TODO: Need a better name for this class  
  class ProjectEventBroadcaster
    
    EVENT_PUBLISH_COUNT_ON_INIT = 25
        
    def initialize(mingle_feed, event_processors, state_file, logger = Logger.new(STDOUT))
      @mingle_feed = mingle_feed
      @event_processors = event_processors
      @state_file = state_file
      @logger = logger
    end  

    # Perform the polling for new events and subsequent broadasting to interested processors
    def process_new_events
      if !initialized?
        process_events(@mingle_feed.entries.take(EVENT_PUBLISH_COUNT_ON_INIT).reverse)
        ensure_state_initialized
      else
        unseen_entries = []
        @mingle_feed.entries.each do |entry|
          break if entry.entry_id == last_event_id
          unseen_entries << entry
        end
        process_events(unseen_entries.reverse) 
      end
    end

    private
        
    def process_events(events)
      @event_processors.each do |processor| 
        begin
          processor.process_events(events)
        rescue StandardError => e
          @logger.info(%{
Unable to complete event processing for processor #{processor}. 
There will be no re-try for one or more of the events below.
Also, some of the events below may have actually been processed.
In order to have a more accurate understanding of which events
were processed and which were not processed you will need to add
more precise error handling to your processor. If you are writing
a publisher/notifier (and not a filter) you should consider writing
a subclass of AbstractNoRetryProcessor in order to narrow the scope
of processing failure to single events.
Root Cause: #{e}
Trace: #{e.backtrace.join("\n")}
Events: #{events}
          })
        end
      end
      
      # TODO: write unit test for not writing state when events is empty (and correlate with the init scenario)
      write_last_event_seen(events.last) unless events.empty?  
    end
    
    def last_event_id
      read_state[:last_event_id]
    end
    
    def initialized?
      File.exist?(@state_file)
    end
    
    def ensure_state_initialized
      write_last_event_seen(nil) unless initialized?
    end
    
    def read_state
      @state ||= YAML.load(File.new(@state_file))
    end

    def write_last_event_seen(last_event)
      FileUtils.mkdir_p(File.dirname(@state_file))
      File.open(@state_file, 'w') do |out|
        YAML.dump({:last_event_id => last_event.nil? ? nil : last_event.entry_id}, out)
      end
    end

  end
end