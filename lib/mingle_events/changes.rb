module MingleEvents
  module Changes
    # Any changes related to the event (if any).
    def changes
      @changes ||= @entry_element.search('.//mingle:change').map(&method(:create_change)).reject { |e| e == nil }
    end

    private
    def create_change change_element
      change = Change.new(change_element)

      changes_types = {
        'card-creation' => lambda { CardCreationChange.new },
        'card-deletion' => lambda { CardDeletionChange.new },
        'name-change' => lambda { NameChange.new(change.old_value, change.new_value) },
        'property-change' => lambda { PropertyChange.new(change.old_value, change.new_value,
                                change.property_name) }
      }

      return changes_types[change.type].call unless !changes_types[change.type]
    end

    class Change
      def initialize(element)
        @element = element
      end

      def type() @element.attribute('type').text end
      def old_value() @element.at('./mingle:old_value').inner_text end
      def new_value() @element.at('./mingle:new_value').inner_text end
      def property_name() @element.at('.//mingle:name').inner_text end
    end
  end
end
