module MingleEvents
  module Processors
    
    # Posts each event in stream to the specified URL
    #--
    # TODO: figure out what to do with basic/digest auth and HTTPS.  are they separate processors?
    class HttpPostPublisher < AbstractNoRetryProcessor

      def initialize(url)
        @url = url
      end

      def process_event(event) 
        Net::HTTP.post_form(URI.parse(@url), {'event' => event.raw_xml}).body
      end
    
    end
  end
end
