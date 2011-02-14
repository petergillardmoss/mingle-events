require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class CategoryTest < Test::Unit::TestCase
    
    def test_equality
      assert_equal(Category::CARD, Category::CARD)
      assert_equal(Category::CARD, Category.new('card', 'http://www.thoughtworks-studios.com/ns/mingle#categories'))
      assert_not_equal(Category::CARD, Category::PAGE)
      assert_not_equal(Category::CARD, nil)
      assert_not_equal(Category::CARD, Object.new)
      assert_equal(:foo, {Category::CARD => :foo}[Category.new('card', 'http://www.thoughtworks-studios.com/ns/mingle#categories')])
    end
    
  end
end