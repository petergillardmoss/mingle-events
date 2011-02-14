module MingleEvents 
  
  # Supports fetching of Mingle resources using HTTP basic auth.
  # Please only use this class to access resources over HTTPS so
  # as not to send credentials over plain-text connections.
  class MingleBasicAuthAccess
    
    include HttpErrorSupport
    
    BASIC_AUTH_HTTP_WARNING = %{     
WARNING!!!
It looks like you are using basic authentication over a plain-text HTTP connection. 
We HIGHLY recommend AGAINST this practice. You should only use basic authentication over
a secure HTTPS connection. Instructions for enabling HTTPS/SSL in Mingle can be found at
<http://www.thoughtworks-studios.com/mingle/3.3/help/advanced_mingle_configuration.html>
WARNING!!
}

    def initialize(base_url, username, password)
      @base_url = base_url
      @username = username
      @password = password
    end

    # Fetch HTTPResponse for the given location. Useful if you wish to handle
    # specific response codes. If you only care about fetching the actual content
    # on a 200, use the fetch page method.
    def fetch_page_response(location)
      location = @base_url + location if location[0..0] == '/' 
      
      uri = URI.parse(location)
      http = Net::HTTP.new(uri.host, uri.port)
      
      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      else
        puts BASIC_AUTH_HTTP_WARNING
      end

      path = uri.path
      path += "?#{uri.query}" if uri.query
      puts "Fetching page at #{path}..."
      
      start = Time.now
      req = Net::HTTP::Get.new(path)
      req.basic_auth(@username, @password)
      rsp = http.request(req)
      puts "...#{Time.now - start}"

      rsp
    end
    
    # Fetch the content at location via HTTP. Throws error if non-200 response.
    def fetch_page(location) 
      rsp = fetch_page_response(location)    
      case rsp
      when Net::HTTPSuccess
        rsp.body
      when Net::HTTPUnauthorized
        raise_non_200(rsp, location, %{
If you think you are passing correct credentials, please check 
that you have enabled Mingle for basic authentication. 
See <http://www.thoughtworks-studios.com/mingle/3.3/help/configuring_mingle_authentication.html>.})
      else
        raise_non_200(rsp, location) 
      end
    end

  end
end