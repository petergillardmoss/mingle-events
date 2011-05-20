require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class ChangeTest < Test::Unit::TestCase

    def test_name_equality
      assert_equal(NameChange.new('name-change', 'old value', 'new value'), NameChange.new('name-change', 'old value', 'new value'))
      assert_not_equal(NameChange.new('name-change', 'old value', 'new value'), NameChange.new('name-change', 'different old value', 'new value'))
      assert_not_equal(NameChange.new('name-change','old value', 'new value'), NameChange.new('name-change', 'old value', 'different new value'))
       assert_not_equal(NameChange.new('name-change','old value', 'new value'), NameChange.new('property-change', 'old value', 'new value'))
    end

    def test_property_change_equality
      assert_equal(PropertyChange.new('old-value', 'new-value', 'Priority'), PropertyChange.new('old-value', 'new-value', 'Priority'))
      assert_not_equal(PropertyChange.new('old-value', 'new-value', 'Priority'), PropertyChange.new('new-value', 'different-new-value', 'Status'))
    end
  end
end
