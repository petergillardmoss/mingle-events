module MingleEvents
  
  # Support for raising errors based upon HTTP status code
  module HttpErrorSupport
    
    def raise_non_200(rsp, location, additional_context = nil)
      msg = %{
Unable to retrieve 200 response from URI: <#{location}>!
HTTP Code: #{rsp.code}
Body: #{rsp.body}}
      if additional_context
        msg += %{        
#{additional_context}
        } 
      end
      raise msg
    end
    
  end
end