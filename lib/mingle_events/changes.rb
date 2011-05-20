module MingleEvents
  module Changes
    # Any changes related to the event (if any).
    def changes
      @changes ||= @entry_element.search('.//mingle:change').map do |change_element|
        Change.new(
                   change_element.attribute('type').text,
                   change_element.at('./mingle:old_value').inner_text,
                   change_element.at('./mingle:new_value').inner_text)
      end
    end

  end
end
