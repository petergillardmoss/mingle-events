require 'test/unit'

require 'ostruct'
require 'fileutils'

require 'rubygems'
require 'active_support'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'mingle_events'))

class Test::Unit::TestCase 
  
  FIRST_PAGE_CONTENT = %{
      <feed xmlns="http://www.w3.org/2005/Atom" xmlns:mingle="http://www.thoughtworks-studios.com/ns/mingle">
        <link href="https://mingle.example.com/api/v2/projects/atlas/feeds/events.xml?page=23" rel="next"/>
        <entry>
          <id>https://mingle.example.com/projects/atlas/events/index/103</id>
          <title>entry 103</title>
          <updated>2011-02-03T08:12:42Z</updated>
          <author><name>Bob</name></author>
        </entry>
        <entry>
          <id>https://mingle.example.com/projects/atlas/events/index/101</id>
          <title>entry 101</title>
          <updated>2011-02-03T02:09:16Z</updated>
          <author><name>Bob</name></author>
        </entry>
        <entry>
          <id>https://mingle.example.com/projects/atlas/events/index/100</id>
          <title>entry 100</title>
          <updated>2011-02-03T01:58:02Z</updated>
          <author><name>Mary</name></author>
        </entry>
      </feed>
    }  
   
  NEXT_PAGE_CONTENT = %{
      <feed xmlns="http://www.w3.org/2005/Atom" xmlns:mingle="http://www.thoughtworks-studios.com/ns/mingle">
        <entry>
          <id>https://mingle.example.com/projects/atlas/events/index/97</id>
          <title>entry 97</title>
          <updated>2011-02-03T01:00:52Z</updated>
          <author><name>Harry</name></author>
        </entry>
      </feed>
    }      

  def stub_mingle_access
    stub = Object.new
    def stub.fetch_page(url)
      {
        'https://mingle.example.com/api/v2/projects/atlas/feeds/events.xml?page=23' => NEXT_PAGE_CONTENT,
        'https://mingle.example.com/api/v2/projects/atlas/feeds/events.xml' => FIRST_PAGE_CONTENT,
      
        # feed uses path only for first page, relying upon mingle access to convert
        # to absolute URI -- might need to revisit this 'design' :)
        '/api/v2/projects/atlas/feeds/events.xml' => FIRST_PAGE_CONTENT
      }[url]
    end
    stub
  end 
  
  def temp_dir
    path = File.expand_path(File.join(File.dirname(__FILE__), 'tmp', ActiveSupport::SecureRandom.hex(16)))
    FileUtils.mkdir_p(path)
    path
  end
  
  def temp_file
    File.join(temp_dir, ActiveSupport::SecureRandom.hex(16))
  end
  
  class StubMingleAccess
    
    def initialize
      @pages_by_path = {}
      @four_oh_fours = []
    end
    
    def register_page_content(path, content)
      @pages_by_path[path] = content
    end
    
    def register_page_not_found(path)
      @four_oh_fours << path
    end
    
    def fetch_page(path)
      raise "Attempting to fetch page at #{path}, but your test has not registered content for this path! Registered paths: #{@pages_by_path.keys.inspect}" unless @pages_by_path.key?(path)
      @pages_by_path[path]
    end
    
    def fetch_page_response(path)
      if @four_oh_fours.include?(path)
        return Net::HTTPNotFound.new(nil, '404', 'Page not found!')
      end
      
      body = fetch_page(path)
      response = Net::HTTPSuccess.new(nil, '200' , "Good!")
      response.instance_variable_set(:@__body, body)
      def response.body
        @__body
      end
      response
    end
    
  end
  
end

