module MingleEvents
  module Processors
    
    # Filters events by card types. As events do not contain the type
    # of the card, this filter requires a lookup against Mingle to 
    # determine the type of the card that sourced the event. In the case
    # of the card's being deleted in the interim between the actual event
    # and this filtering, the event will be filtered as there is no means
    # to determine its type. Therefore, it's recommended to also
    # subscribe a 'CardDeleted' processor to the same project.    
    class CardTypeFilter
    
      def initialize(card_types, card_data)
        @card_types = card_types
        @card_data = card_data
      end
    
      def process_events(events)
        events.select do |event|
          event.card? && 
            @card_data.for_card_event(event) &&
            @card_types.include?(@card_data.for_card_event(event)[:card_type_name])
        end
      end

    end
  end
end