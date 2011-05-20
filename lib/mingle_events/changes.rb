module MingleEvents
  module Changes
    # Any changes related to the event (if any).
    def changes
      @changes ||= @entry_element.search('.//mingle:change').map &method(:create_change)
    end

    private
    def create_change change_element
      change_type = change_element.attribute('type').text

      return CardCreationChange.new if change_type == 'card-creation'
      return CardDeletionChange.new if change_type == 'card-deletion'

      old_value = change_element.at('./mingle:old_value').inner_text
      new_value = change_element.at('./mingle:new_value').inner_text

      return NameChange.new(old_value, new_value) if change_type == 'name-change'
      return PropertyChange.new(old_value, new_value,
                                change_element.at('.//mingle:name').inner_text) if change_type == 'property-change'
    end
  end
end
