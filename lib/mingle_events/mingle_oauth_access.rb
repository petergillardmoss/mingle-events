module MingleEvents 
  
  # Client for Mingle's experimental OAuth 2.0 support in 3.0
  #--
  # TODO: Update error handling and support of fetching response
  # objects to that of MingleBasicAuthAccess
  class MingleOauthAccess

    def initialize(base_url, token)
      @base_url = base_url
      @token = token
    end

    def fetch_page(location)
      location = @base_url + location if location[0..0] == '/' 
      
      uri = URI.parse(location)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      headers = {
        'Authorization' => %{Token token="#{@token}"}
      }

      path = uri.path
      path += "?#{uri.query}" if uri.query
      puts "Fetching page at #{path}..."
      
      start = Time.now
      response = http.get(path, headers)
      puts "...#{Time.now - start}"

      # todo: what's the right way to raise on non 200 ?
      # raise StandardError.new(response.body) unless response == Net::HTTPSuccess
      
      response.body
    end

  end
end