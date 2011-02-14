require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class AuthorTest < Test::Unit::TestCase
  
    def test_parse_attributes
      element = Hpricot.XML(%{
        <author>
          <name>Sammy Soso</name>
          <email>sammy@example.com</email>
          <uri>https://mingle.example.com/api/v2/users/233.xml</uri>
          <mingle:icon>https://mingle.example.com/user/icon/233/profile.jpg</mingle:icon>
        </author>})
      author = Author.new(element)
      assert_equal("Sammy Soso", author.name)
      assert_equal("sammy@example.com", author.email)
      assert_equal("https://mingle.example.com/api/v2/users/233.xml", author.uri)
      assert_equal("https://mingle.example.com/user/icon/233/profile.jpg", author.icon_uri)
    end
    
    def test_parse_attributes_when_no_optional_fields
      element = Hpricot.XML(%{
        <author>
          <name>Sammy Soso</name>
        </author>})
      author = Author.new(element)
      assert_equal("Sammy Soso", author.name)
      assert_nil(author.email)
      assert_nil(author.uri)
      assert_nil(author.icon_uri)
    end
  
  end
end
