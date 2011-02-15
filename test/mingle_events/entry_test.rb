require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class EntryTest < Test::Unit::TestCase
  
    def test_parse_basic_attributes
      element_xml_text = %{
        <entry xmlns:mingle="http://www.thoughtworks-studios.com/ns/mingle">
          <id>https://mingle.example.com/projects/mingle/events/index/234443</id>
          <title>Page Special:HeaderActions changed</title>
          <updated>2011-02-03T08:12:42Z</updated>
          <author>
            <name>Sammy Soso</name>
            <email>sammy@example.com</email>
            <uri>https://mingle.example.com/api/v2/users/233.xml</uri>
          </author>
        </entry>}
      element = Nokogiri::XML(element_xml_text)
      
      entry = Entry.new(element)
      # assert_equal(element_xml_text.inspect, entry.raw_xml.inspect) 
      assert_equal("https://mingle.example.com/projects/mingle/events/index/234443", entry.entry_id)
      assert_equal("Page Special:HeaderActions changed", entry.title)
      assert_equal("Thu Feb 03 08:12:42 UTC 2011", entry.updated.to_s)
      assert_equal("Sammy Soso", entry.author.name)
    end
    
    def test_parse_categories
      element_xml_text = %{
        <entry xmlns:mingle="http://www.thoughtworks-studios.com/ns/mingle">
          <category term="foo" scheme='http://tws.com/ns#mingle' />
          <category term="bar" scheme="http://tws.com/ns#go" />
        </entry>}
      element = Nokogiri::XML(element_xml_text)
        
      entry = Entry.new(element)
      assert_equal(
        [Category.new('foo', 'http://tws.com/ns#mingle'), Category.new('bar', 'http://tws.com/ns#go')],
        entry.categories
      )
    end
    
    def test_parse_card_number_and_version
      
      # the links below contain intentionally nonsensical data so as to ensure
      # that the card number is derived from a single, precise position
      
      element_xml_text = %{
        <entry xmlns:mingle="http://www.thoughtworks-studios.com/ns/mingle">
          <category term="card" scheme="http://www.thoughtworks-studios.com/ns/mingle#categories"/>
          <link href="https://mingle.example.com/projects/atlas/cards/102" rel="http://www.thoughtworks-studios.com/ns/mingle#event-source" type="text/html" title="bug #103"/>
          <link href="https://mingle.example.com/api/v2/projects/atlas/cards/104.xml?version=7" rel="http://www.thoughtworks-studios.com/ns/mingle#version" type="application/vnd.mingle+xml" title="bug #105 (v7)"/>
          <link href="https://mingle.example.com/api/v2/projects/atlas/cards/106.xml" rel="http://www.thoughtworks-studios.com/ns/mingle#event-source" type="application/vnd.mingle+xml" title="bug #107"/>
          <link href="https://mingle.example.com/projects/atlas/cards/108?version=17" rel="http://www.thoughtworks-studios.com/ns/mingle#version" type="text/html" title="bug #109 (v7)"/>
        </entry>}
      element = Nokogiri::XML(element_xml_text)
      
      entry = Entry.new(element)
      assert_equal(106, entry.card_number)
      assert_equal(7, entry.version)
    end
    
    def test_card_number_and_version_throws_error_when_event_not_related_to_a_card      
      element_xml_text = %{
        <entry xmlns:mingle="http://www.thoughtworks-studios.com/ns/mingle">
          <category term="page" scheme="http://www.thoughtworks-studios.com/ns/mingle#categories"/>
        </entry>}
      element = Nokogiri::XML(element_xml_text)
      
      entry = Entry.new(element)
      
      begin
        entry.card_number
        fail("Should not have been able to retrieve a card number for non card-related event!")
      rescue Exception => e
        assert_equal("You cannot get the card number for an event that is not sourced by a card!", e.message)
      end
      
      begin
        entry.version
        fail("Should not have been able to retrieve a card version for non card-related event!")
      rescue Exception => e
        assert_equal("You cannot get card version data for an event that is not sourced by a card!", e.message)
      end
      
    end
    
    def test_parse_card_version_resource_uri
      
      # the links below contain intentionally nonsensical data so as to ensure
      # that the card number is derived from a single, precise position
      
      element_xml_text = %{
        <entry xmlns:mingle="http://www.thoughtworks-studios.com/ns/mingle">
          <category term="card" scheme="http://www.thoughtworks-studios.com/ns/mingle#categories"/>
          <link href="https://mingle.example.com/projects/atlas/cards/102" rel="http://www.thoughtworks-studios.com/ns/mingle#event-source" type="text/html" title="bug #103"/>
          <link href="https://mingle.example.com/api/v2/projects/atlas/cards/104.xml?version=7" rel="http://www.thoughtworks-studios.com/ns/mingle#version" type="application/vnd.mingle+xml" title="bug #105 (v7)"/>
          <link href="https://mingle.example.com/api/v2/projects/atlas/cards/106.xml" rel="http://www.thoughtworks-studios.com/ns/mingle#event-source" type="application/vnd.mingle+xml" title="bug #107"/>
          <link href="https://mingle.example.com/projects/atlas/cards/108?version=7" rel="http://www.thoughtworks-studios.com/ns/mingle#version" type="text/html" title="bug #109 (v7)"/>
        </entry>}
      element = Nokogiri::XML(element_xml_text)
      
      entry = Entry.new(element)
      assert_equal('https://mingle.example.com/api/v2/projects/atlas/cards/104.xml?version=7', entry.card_version_resource_uri)
    end
    
    def test_card_version_resource_uri_throws_error_when_not_card_event
      element_xml_text = %{
        <entry xmlns:mingle="http://www.thoughtworks-studios.com/ns/mingle">
          <category term="page" scheme="http://www.thoughtworks-studios.com/ns/mingle#categories"/>
        </entry>}
      element = Nokogiri::XML(element_xml_text)
      
      entry = Entry.new(element)
      begin
        entry.card_version_resource_uri
        fail("Should not have been able to retrieve a card version resource URI for non card-related event!")
      rescue Exception => e
        assert_equal("You cannot get card version data for an event that is not sourced by a card!", e.message)
      end
    end
    
    def test_entry_id_aliased_as_event_id
      element_xml_text = %{
        <entry xmlns:mingle="http://www.thoughtworks-studios.com/ns/mingle">
          <id>https://mingle.example.com/projects/mingle/events/index/234443</id>
        </entry>}
      element = Nokogiri::XML(element_xml_text)
      
      entry = Entry.new(element)
      assert_equal('https://mingle.example.com/projects/mingle/events/index/234443', entry.event_id)
      assert_equal(entry.entry_id, entry.event_id)
    end
      
  end
end
