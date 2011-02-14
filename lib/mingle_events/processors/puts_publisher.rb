module MingleEvents
  module Processors
    
    # Writes each event in stream to stdout, mostly for demonstration purposes
    class PutsPublisher < AbstractNoRetryProcessor

      def process_event(event) 
        puts "Processing event #{event.entry_id}"
      end
    
    end
  end
end
