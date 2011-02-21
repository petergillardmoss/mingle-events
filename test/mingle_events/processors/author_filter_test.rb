require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'test_helper'))

module MingleEvents
  module Processors
    class AuthorFilterTest < Test::Unit::TestCase
  
      def test_filter_by_author
        event_1 = stub_event(1, {:uri => "http://example.com/users/10.xml"})
        event_2 = stub_event(2, {:uri => "http://example.com/users/17.xml"})
        event_3 = stub_event(3, {:uri => "http://example.com/users/10.xml"})
        
        dummy_mingle_access = StubMingleAccess.new
        dummy_mingle_access.register_page_content(
          '/api/v2/projects/atlas/team.xml',
          %{
          <projects_members type="array"> 
            <projects_member> 
              <user url="http://example.com/users/10.xml"> 
                <id type="integer">333</id> 
                <name>Chester Tester</name> 
                <login>ctester</login> 
                <email>chester.tester@example.com</email>
              </user>
            </proejcts_member>
            <projects_member> 
              <user url="http://example.com/users/17.xml"> 
                <id type="integer">444</id> 
                <name>Joe Developer</name> 
                <login>jdeveloper</login> 
                <email>joe.developer@example.com</email>
              </user>
            </proejcts_member>
          <projects_members>
          } 
        )
        
        author_filter = AuthorFilter.new({:url => 'http://example.com/users/10.xml'}, dummy_mingle_access, 'atlas')
        filtered_events = author_filter.process_events([event_1, event_2, event_3])
        assert_equal([event_1, event_3], filtered_events)
      end
      
      private
      
      def stub_event(entry_id, author)
        OpenStruct.new(:entry_id => entry_id, :author => OpenStruct.new(author))
      end
      
    end
  end
end
