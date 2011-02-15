require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class PageTest < Test::Unit::TestCase
    
    def test_entries_are_enumerable   
      latest_entries_page = Page.new('https://mingle.example.com/api/v2/projects/atlas/feeds/events.xml', stub_mingle_access)
      
      assert_equal([
        'https://mingle.example.com/projects/atlas/events/index/103',
        'https://mingle.example.com/projects/atlas/events/index/101',
        'https://mingle.example.com/projects/atlas/events/index/100'
        ], latest_entries_page.entries.map(&:entry_id))  
    end
    
    def test_next_page_returns_the_next_page_of_entries_as_specified_by_next_link
      latest_entries_page = Page.new('https://mingle.example.com/api/v2/projects/atlas/feeds/events.xml', stub_mingle_access)
      next_page = latest_entries_page.next
      assert_equal('https://mingle.example.com/api/v2/projects/atlas/feeds/events.xml?page=23', latest_entries_page.next.url)
      assert_equal(['https://mingle.example.com/projects/atlas/events/index/97'], next_page.entries.map(&:entry_id))
    end
    
    def test_next_page_when_on_last_page
      last_page = Page.new('https://mingle.example.com/api/v2/projects/atlas/feeds/events.xml?page=23', stub_mingle_access)
      assert_nil(last_page.next)
    end

  end
end