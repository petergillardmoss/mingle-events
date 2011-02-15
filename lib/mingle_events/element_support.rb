module MingleEvents
  
  # Provides some helpers for pulling values from Nokogiri Elems
  module ElementSupport
    
    def element_text(parent_element, element_name, optional = false)
      element = parent_element.at(".//#{element_name}")
      if optional && element.nil?
        nil
      else
        element.inner_text
      end
    end
    
  end
end