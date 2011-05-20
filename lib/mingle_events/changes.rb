module MingleEvents
  module Changes
    # Any changes related to the event (if any).
    def changes
      @changes ||= @entry_element.search('.//mingle:change').map &method(:create_change)
    end

    private
    def create_change change_element
      change_type = change_element.attribute('type').text

      def change_element.old_value() at('./mingle:old_value').inner_text end
      def change_element.new_value() at('./mingle:new_value').inner_text end

      changes_types = {
        'card-creation' => lambda { CardCreationChange.new },
        'card-deletion' => lambda { CardDeletionChange.new },
        'name-change' => lambda { NameChange.new(change_element.old_value, change_element.new_value)  }
      }

      return changes_types[change_type].call unless !changes_types[change_type]


      return PropertyChange.new(change_element.old_value, change_element.new_value,
                                change_element.at('.//mingle:name').inner_text) if change_type == 'property-change'
    end

  end
end
