require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'test_helper'))

module MingleEvents
  module Processors
    class PipelineTest < Test::Unit::TestCase  
      
      def test_chains_all_processors
        events = [stub_event(100), stub_event(101), stub_event(102)]
        pipeline = Pipeline.new([DeleteLastProcessor.new, ReversingProcessor.new])
        processed_events = pipeline.process_events(events)
        assert_equal([101, 100], processed_events.map(&:entry_id))
      end
  
      def stub_event(id)
        OpenStruct.new(:entry_id => id)
      end
      
      class ReversingProcessor
        def process_events(events)
          events.reverse
        end
      end

      class DeleteLastProcessor
        def process_events(events)
          events[0..-2]
        end
      end

    end
  end
end
