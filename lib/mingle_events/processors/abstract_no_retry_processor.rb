module MingleEvents
  module Processors
    
    # Loops through the stream of events, asking the subclass to process each event,
    # one at a time. If the processing of a single event fails, the failure is logged
    # and processing continues. Allows subclasses to be concerned solely with single
    # event processing and not streams or error handling.
    #--
    # TODO: Figure out a better class name
    class AbstractNoRetryProcessor
      
      def initialize(dead_letter_office = WarnToStdoutDeadLetterOffice.new)
        @dead_letter_office = dead_letter_office
      end
   
      def process_events(events)
        events.map do |event|
          begin 
            process_event(event)
          rescue StandardError => e
            @dead_letter_office.deliver(e, event)
          end
          event
        end
        events
      end
    
      def process_event(event)
        raise "Subclass responsibility!"
      end
      
      class WarnToStdoutDeadLetterOffice
        def deliver(error, *events)
          Logger.new(STDOUT).info(%{
Unable to process event and #{self} was not constructed with a dead letter office.
Event: #{events}
Error: #{error}
})
        end
      end
    end
  end
end