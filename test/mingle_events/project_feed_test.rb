require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class ProjectFeedTest < Test::Unit::TestCase
    
    def test_can_enumerate_entries_across_pages
      feed = ProjectFeed.new('atlas', stub_mingle_access)
      assert_equal([
        'https://mingle.example.com/projects/atlas/events/index/103',
        'https://mingle.example.com/projects/atlas/events/index/101',
        'https://mingle.example.com/projects/atlas/events/index/100',
        'https://mingle.example.com/projects/atlas/events/index/97'
        ], feed.entries.map(&:entry_id))
    end
    
  end
end