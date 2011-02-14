require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'test_helper'))

module MingleEvents
  module Processors
    class CategoryFilterTest < Test::Unit::TestCase
  
      def test_removes_events_without_matching_categories
        event_1 = stub_event(1, [Category::CARD, Category::COMMENT_ADDITION])
        event_2 = stub_event(2, [Category::CARD, Category::PROPERTY_CHANGE])
        event_3 = stub_event(3, [Category::REVISION_COMMIT])
        event_4 = stub_event(4, [Category::CARD, Category::PROPERTY_CHANGE])
        event_5 = stub_event(5, [])
        events = [event_1, event_2, event_3, event_4, event_5]
    
        filter = CategoryFilter.new([Category::CARD, Category::PROPERTY_CHANGE])
        assert_equal([event_2, event_4], filter.process_events(events))
      end
      
      private 
  
      def stub_event(id, categories)
        OpenStruct.new(:entry_id => id, :categories => categories)
      end

    end
  end
end
