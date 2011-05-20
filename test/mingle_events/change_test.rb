require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class ChangeTest < Test::Unit::TestCase

    def test_equality
      assert_equal(Change.new('name-change', 'old value', 'new value'), Change.new('name-change', 'old value', 'new value'))
      assert_not_equal(Change.new('name-change', 'old value', 'new value'), Change.new('name-change', 'different old value', 'new value'))
      assert_not_equal(Change.new('name-change','old value', 'new value'), Change.new('name-change', 'old value', 'different new value'))
       assert_not_equal(Change.new('name-change','old value', 'new value'), Change.new('property-change', 'old value', 'new value'))
    end

    def test_property_change_equality
      assert_equal(PropertyChange.new('old-value'), PropertyChange.new('old-value'))
      assert_not_equal(PropertyChange.new('old-value'), PropertyChange.new('different-old-value'))
    end
  end
end
