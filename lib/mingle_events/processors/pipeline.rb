module MingleEvents
  module Processors
    
    # Manages the passing of a stream of events through a sequence of processors
    class Pipeline
      
      def initialize(processors)
        @processors = processors
      end
      
      def process_events(events)
        processed_events = events
        @processors.each do |processor|
          processed_events = processor.process_events(processed_events)
        end
        processed_events
      end
    end
  end
end