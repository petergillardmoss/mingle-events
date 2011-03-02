require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'test_helper'))

module MingleEvents
  module Processors
    class AuthorFilterTest < Test::Unit::TestCase
      
      def setup
        @dummy_mingle_access = StubMingleAccess.new
        @dummy_mingle_access.register_page_content(
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
        
        @event_1 = stub_event(1, {:uri => "http://example.com/users/10.xml", :login => 'ctester'})
        @event_2 = stub_event(2, {:uri => "http://example.com/users/17.xml", :login => 'jdeveloper'})
        @event_3 = stub_event(3, {:uri => "http://example.com/users/10.xml", :login => 'ctester'})
        @unprocessed_events = [@event_1, @event_2, @event_3]
      end
      
      def test_filter_can_only_be_constructed_with_a_single_criteria
        begin
          AuthorFilter.new({:url => 'foo', :email => 'bar'}, nil, nil)
          fail("Should not have been able to construct this filter!")
        rescue StandardError => e
                 assert_equal(0, e.message.index("Author spec must contain 1 and only 1 piece of criteria"))
               end
      end
  
      def test_filter_by_author_url
        author_filter = AuthorFilter.new({:url => 'http://example.com/users/10.xml'}, @dummy_mingle_access, 'atlas')
        filtered_events = author_filter.process_events(@unprocessed_events)
        assert_equal([@event_1, @event_3], filtered_events)
      end
      
      def test_filter_by_author_login
        author_filter = AuthorFilter.new({:login => 'ctester'}, @dummy_mingle_access, 'atlas')
        filtered_events = author_filter.process_events(@unprocessed_events)
        assert_equal([@event_1, @event_3], filtered_events)
      end
      
      def test_filter_by_author_email
        author_filter = AuthorFilter.new({:email => 'joe.developer@example.com'}, @dummy_mingle_access, 'atlas')
        filtered_events = author_filter.process_events(@unprocessed_events)
        assert_equal([@event_2], filtered_events)
      end
      
      def test_filter_returns_empty_list_when_no_match
        author_filter = AuthorFilter.new({:email => 'sammy.soso@example.com'}, @dummy_mingle_access, 'atlas')
        filtered_events = author_filter.process_events(@unprocessed_events)
        assert_equal([], filtered_events)
      end
      
      private
      
      def stub_event(entry_id, author)
        OpenStruct.new(:entry_id => entry_id, :author => OpenStruct.new(author))
      end
      
    end
  end
end
