require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'test_helper'))

module MingleEvents
  module Processors
    
    class CardTypeFilterTest < Test::Unit::TestCase
  
      def test_filters_events_on_card_type
        event_1 = stub_event(true)
        event_2 = stub_event(false)
        event_3 = stub_event(true)
        event_4 = stub_event(true)
        event_5 = stub_event(true)
        
        card_data = {
          event_1 => {:card_type_name => 'story'},
          event_3 => {:card_type_name => 'bug'},
          event_4 => {:card_type_name => 'story'},
          event_5 => {:card_type_name => 'issue'}
        }
        def card_data.for_card_event(card_event)
          self[card_event]
        end
        
        filter = CardTypeFilter.new(['story', 'issue'], card_data)
        filtered_events = filter.process_events([event_1, event_2, event_3, event_4, event_5])
        assert_equal([event_1, event_4, event_5], filtered_events)
      end
      
      def test_drops_events_for_deleted_cards
        event_1 = stub_event(true)
        
        card_data = {}
        def card_data.for_card_event(card_event)
          self[card_event]
        end
        
        filter = CardTypeFilter.new(['story', 'issue'], card_data)
        filtered_events = filter.process_events([event_1])
        assert_equal([], filtered_events)
      end
      
      private
      
      def stub_event(is_card)
        OpenStruct.new(:card? => is_card)
      end
      
    end
  end
end
