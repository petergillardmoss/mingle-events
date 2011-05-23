require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module MingleEvents
  class ChangeTest < Test::Unit::TestCase

    def test_name_equality
      assert_equal(NameChange.new('old value', 'new value'), NameChange.new('old value', 'new value'))
      assert_not_equal(NameChange.new('old value', 'new value'), NameChange.new('different old value', 'new value'))
      assert_not_equal(NameChange.new('old value', 'new value'), NameChange.new('old value', 'different new value'))
    end

    def test_property_change_equality
      assert_equal(PropertyChange.new('old-value', 'new-value', 'Priority'), PropertyChange.new('old-value', 'new-value', 'Priority'))
      assert_not_equal(PropertyChange.new('old-value', 'new-value', 'Priority'), PropertyChange.new('new-value', 'different-new-value', 'Status'))
    end

    def test_comment_addition_change
      assert_equal(CommentAdditionChange.new('commenting on the card'), CommentAdditionChange.new('commenting on the card'))
      assert_not_equal(CommentAdditionChange.new('commenting on the card'), CommentAdditionChange.new('commenting again'))
    end

    def test_card_created_change_equality
      assert_equal(CardCreationChange.new, CardCreationChange.new)
      assert_not_equal(CardCreationChange.new, CardDeletionChange.new)
    end

    def test_card_deletion_change_equality
      assert_equal(CardDeletionChange.new, CardDeletionChange.new)
      assert_not_equal(CardDeletionChange.new, CardCreationChange.new)
    end

    def test_description_change
      assert_equal(DescriptionChange.new, DescriptionChange.new)
      assert_not_equal(DescriptionChange.new, CardCreationChange.new)
    end

  end
end
