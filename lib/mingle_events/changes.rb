module MingleEvents
  module Changes
    # Any changes related to the event (if any).
    def changes
      @changes ||= @entry_element.search('.//mingle:change').map do |change_element|
        create_change change_element
      end
    end

    private
    def create_change change_element
      change_type = change_element.attribute('type').text
      return NameChange.new(
                        change_element.at('./mingle:old_value').inner_text,
                        change_element.at('./mingle:new_value').inner_text) if change_type == 'name-change'

      return PropertyChange.new(
                                change_element.at('./mingle:old_value').inner_text,
                                change_element.at('./mingle:new_value').inner_text,
                                change_element.at('.//mingle:name').inner_text) if change_type == 'property-change'
    end
  end
end
