require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class ChangesTest < Test::Unit::TestCase

    def test_parse_changes
      element_xml_text = %{
        <entry xmlns:mingle="http://www.thoughtworks-studios.com/ns/mingle">
          <content type="application/vnd.mingle+xml">
            <changes xmlns="http://www.thoughtworks-studios.com/ns/mingle">
              <change type="name-change">
                <old_value>Old name 1</old_value>
                <new_value>New name 1</new_value>
              </change>
              <change type="property-change">
                <old_value>Old name 2</old_value>
                <new_value>New name 2</new_value>
              </change>
            </changes>
          </content>
        </entry>}
      element = Nokogiri::XML(element_xml_text)

      entry = Object.new
      entry.extend(Changes)
      entry.instance_variable_set('@entry_element', element)
      assert_equal(
         [Change.new('name-change', 'Old name 1', 'New name 1'), Change.new('property-change', 'Old name 2', 'New name 2')],
         entry.changes
      )
    end

    def test_no_changes
      element_xml_text = %{ <entry xmlns:mingle="http://www.thoughtworks-studios.com/ns/mingle" /> }
      element = Nokogiri::XML(element_xml_text)

      entry = Object.new
      entry.extend(Changes)
      entry.instance_variable_set('@entry_element', element)
      assert_equal([], entry.changes)
    end
  end
end
