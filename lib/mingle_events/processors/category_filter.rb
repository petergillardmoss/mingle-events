module MingleEvents
  module Processors
    
    # Removes events from the stream that do not match all of the specified categories
    class CategoryFilter
    
      def initialize(categories)
        @categories = categories
      end
    
      def process_events(events)
        events.select do |event|
          @categories.all?{|c| event.categories.include?(c)}
        end
      end
    
    end
  end
end