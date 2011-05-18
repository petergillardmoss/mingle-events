require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class ChangeTest < Test::Unit::TestCase

    def test_equality
      assert_equal(Change.new, Change.new)
    end

  end
end
