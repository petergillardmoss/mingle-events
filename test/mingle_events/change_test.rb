require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class ChangeTest < Test::Unit::TestCase

    def test_equality
      assert_equal(Change.new('old value', 'new value', 'name-change'), Change.new('old value', 'new value', 'name-change'))
      assert_not_equal(Change.new('old value', 'new value', 'name-change'), Change.new('different old value', 'new value', 'name-change'))
      assert_not_equal(Change.new('old value', 'new value', 'name-change'), Change.new('old value', 'different new value', 'name-change'))
       assert_not_equal(Change.new('old value', 'new value', 'name-change'), Change.new('old value', 'new value', 'property-change'))
    end

  end
end
