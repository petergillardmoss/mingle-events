require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class ProjectEventBroadcasterTest < Test::Unit::TestCase
    
    def test_processes_25_events_on_project_initialization
      processor = DummyAbstractNoRetryProcessor.new
      feed = DummyFeed.new
      event_pump = ProjectEventBroadcaster.new(feed, [processor], temp_file)
      event_pump.process_new_events
      
      assert_equal(25, processor.processed_events.count)
      assert_equal('http://example.com/entry/6', processor.processed_events.first.entry_id)
      assert_equal('http://example.com/entry/30', processor.processed_events.last.entry_id)
    end
    
    def test_initializes_new_project_even_when_no_new_events
      processor = DummyAbstractNoRetryProcessor.new
      feed = DummyFeed.new(0)
      state_file = temp_file
      event_pump = ProjectEventBroadcaster.new(feed, [processor], state_file)
      event_pump.process_new_events
      
      feed = DummyFeed.new
      event_pump = ProjectEventBroadcaster.new(feed, [processor], state_file)
      event_pump.process_new_events
      
      # we would only get beyond a page of events if previously initialized
      assert_equal(30, processor.processed_events.count)
    end
    
    def test_publishses_all_events_beyond_last_event_for_initialized_project
      state_file = temp_file
      File.open(state_file, 'w') do |io|
        YAML.dump({:last_event_id => 'http://example.com/entry/28'}, io)
      end
      
      processor = DummyAbstractNoRetryProcessor.new
      feed = DummyFeed.new
      event_pump = ProjectEventBroadcaster.new(feed, [processor], state_file)    
      event_pump.process_new_events
      
      assert_equal(
        ['http://example.com/entry/29', 'http://example.com/entry/30'], 
        processor.processed_events.map(&:entry_id)
      )
    end
    
    def test_does_nothing_when_no_new_events
      processor = DummyAbstractNoRetryProcessor.new
      feed = DummyFeed.new(5)
      state_file = temp_file
      event_pump = ProjectEventBroadcaster.new(feed, [processor], temp_file)
      event_pump.process_new_events
      assert_equal(5, processor.processed_events.count)
      
      processor = DummyAbstractNoRetryProcessor.new
      feed = DummyFeed.new(0)
      event_pump = ProjectEventBroadcaster.new(feed, [processor], temp_file)
      assert_equal(0, processor.processed_events.count)
    end
    
    def test_publishes_to_all_subscribers
      processor_1 = DummyAbstractNoRetryProcessor.new
      processor_2 = DummyAbstractNoRetryProcessor.new
      feed = DummyFeed.new(2)
      event_pump = ProjectEventBroadcaster.new(feed, [processor_1, processor_2], temp_file)
      event_pump.process_new_events
      
      assert_equal(2, processor_1.processed_events.count)
      assert_equal(2, processor_2.processed_events.count)
    end
    
    #--
    # TODO: validate that this test is even remotely legit. i'm not feeling good
    # about this failure scenario :(
    def test_failure_during_process_events_does_not_block_other_processors_from_processing_events
      good_processor_1 = DummyAbstractNoRetryProcessor.new
      exploding_processor = DummyAbstractNoRetryProcessor.new
      def exploding_processor.process_events(events)
        events.each do |event|
          process_event(event)
        end
        events
      end
      def exploding_processor.process_event(event)
        if event.entry_id == 'http://example.com/entry/29'
          raise "Blowing up on 29!"
        else
          super(event)
        end
      end
      good_processor_2 = DummyAbstractNoRetryProcessor.new
      
      feed = DummyFeed.new(3)
      log_stream = StringIO.new
      event_pump = ProjectEventBroadcaster.new(
        feed, [good_processor_1, exploding_processor, good_processor_2], 
        temp_file, Logger.new(log_stream))
      event_pump.process_new_events
      
      assert(log_stream.string.index('Unable to complete event processing'))
      assert_equal(
        ['http://example.com/entry/28', 'http://example.com/entry/29', 'http://example.com/entry/30'], 
        good_processor_1.processed_events.map(&:entry_id))      
      assert_equal(
        ['http://example.com/entry/28'], 
        exploding_processor.processed_events.map(&:entry_id))      
      assert_equal(
        ['http://example.com/entry/28', 'http://example.com/entry/29', 'http://example.com/entry/30'], 
        good_processor_2.processed_events.map(&:entry_id))      
    end
        
    class DummyAbstractNoRetryProcessor < MingleEvents::Processors::AbstractNoRetryProcessor
      
      attr_reader :processed_events
      
      def initialize
        @processed_events = []
      end
      
      def process_event(event)
        @processed_events << event
      end
      
    end
    
    class DummyFeed
      
      LAST_ENTRY = 30
      
      def initialize(entry_count = LAST_ENTRY)
        @entry_count = entry_count
        @fixed_time_point = Time.parse('2011-02-03T01:00:52Z')
      end
      
      def entries
        (LAST_ENTRY.downto(LAST_ENTRY - @entry_count + 1)).map do |i| 
          OpenStruct.new(
            :entry_id => "http://example.com/entry/#{i}",
            :updated => @fixed_time_point - i
          )
        end
      end
      
    end
    
    class DummyDeadLetterOffice
      attr_reader :unprocessed_events
      def deliver(error, *events)
        events.each{|e| (@unprocessed_events ||= []) << e}
      end
    end
     
  end
end