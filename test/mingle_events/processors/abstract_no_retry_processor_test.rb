require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'test_helper'))

module MingleEvents
  module Processors
    class AbstractNoRetryProcessorTest < Test::Unit::TestCase  
      
      def test_processes_all_events
        events = [stub_event(100), stub_event(101), stub_event(102)]
        processor = DummyProcessor.new(nil)
        processor.process_events(events)
        assert_equal([100, 101, 102], processor.processed_events.map(&:entry_id))
      end
      
      def test_sends_unprocessable_events_to_the_dead_letter_office
        events = [stub_event(100), stub_event(101), stub_event(102)]
        dead_letter_office = DummyDeadLetterOffice.new
        processor = DummyProcessor.new(dead_letter_office, [101])
        processor.process_events(events)
        assert_equal([100, 102], processor.processed_events.map(&:entry_id))        
        assert_equal([101], dead_letter_office.unprocessed_events.map(&:entry_id))        
      end
  
      def stub_event(id)
        OpenStruct.new(:entry_id => id)
      end
      
      class DummyDeadLetterOffice
        attr_reader :unprocessed_events
        def deliver(error, *events)
          events.each{|e| (@unprocessed_events ||= []) << e}
        end
      end
      
      class DummyProcessor < MingleEvents::Processors::AbstractNoRetryProcessor
        attr_reader :processed_events
        
        def initialize(dead_letter_office, explode_on_ids = [])
          super(dead_letter_office)
          @explode_on_ids = explode_on_ids
        end
        
        def process_event(event)
          raise "Exploding on event processing!" if @explode_on_ids.index(event.entry_id)
          (@processed_events ||= []) << event
        end
      end

    end
  end
end
