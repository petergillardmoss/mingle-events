require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class ChangeTest < Test::Unit::TestCase

    def test_equality
      assert_equal(Change.new('old value'), Change.new('old value'))
      assert_not_equal(Change.new('old value'), Change.new('different value'))
    end

  end
end
