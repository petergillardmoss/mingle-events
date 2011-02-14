module MingleEvents
  
  # An Atom category, with a term and a scheme. Note that an Atom
  # event can have any number of categories, including zero.
  # All current Mingle categories are also defined here, as constants.
  class Category
    
    # The category's term
    attr_reader :term
    # The category's scheme
    attr_reader :scheme
    
    def initialize(term, scheme)
      @term = term
      @scheme = scheme
    end
    
    def ==(other)
      other.is_a?(Category) && other.term == self.term && other.scheme == self.scheme    
    end
    
    def hash
      term.hash ^ scheme.hash
    end
    
    def eql?(other)
      self == other
    end
    
    # The Atom category scheme for all Mingle categories
    MINGLE_SCHEME = 'http://www.thoughtworks-studios.com/ns/mingle#categories'
    
    # Category for any event sourced by a card
    CARD = Category.new('card', MINGLE_SCHEME)
    # Category for any event that is the creation of a new card
    CARD_CREATION = Category.new('card-creation', MINGLE_SCHEME)
    # Category for any event that is the deletion of a card
    CARD_DELETION = Category.new('card-deletion', MINGLE_SCHEME)
    # Category for any event that includes the change of a card's property value
    PROPERTY_CHANGE = Category.new('property-change', MINGLE_SCHEME)
    # Category for any event that includes the change of a card's type
    CARD_TYPE_CHANGE = Category.new('card-type-change', MINGLE_SCHEME)
    # Category for any event that includes the commenting on a card
    COMMENT_ADDITION = Category.new('comment-addition', MINGLE_SCHEME)
    # Category for any event that incldues the Mingle server's adding a comment to a card
    SYSTEM_COMMENT_ADDITION = Category.new('system-comment-addition', MINGLE_SCHEME)
   
    # Category for any event sourced by a wiki page
    PAGE = Category.new('page', MINGLE_SCHEME)
    # Category for any event that is the creation of a new wiki page
    PAGE_CREATION = Category.new('page-creation', MINGLE_SCHEME)
   
    # Category for any event that includes a card or page name change
    NAME_CHANGE = Category.new('name-change', MINGLE_SCHEME)
    # Category for any event that includes a card or page description/content change
    DESCRIPTION_CHANGE = Category.new('description-change', MINGLE_SCHEME)
    # Category for any event that includes the tagging of a card or page
    TAG_ADDITION = Category.new('tag-addition', MINGLE_SCHEME)
    # Category for any event that includes the removal of a tag from a card or page
    TAG_REMOVAL = Category.new('tag-removal', MINGLE_SCHEME)
    # Category for any event that includes the addition of an attachment to a card or page
    ATTACHMENT_ADDITION = Category.new('attachment-addition', MINGLE_SCHEME)
    # Category for any event that includes the removal of an attachment from a card or page
    ATTACHMENT_REMOVAL = Category.new('attachment-removal', MINGLE_SCHEME)
    # Category for any event that includes the replacement of an attachment on a card or page
    ATTACHMENT_REPLACEMENT = Category.new('attachment-replacement', MINGLE_SCHEME)
   
    # Category for any event that is a revision or changeset commit
    REVISION_COMMIT = Category.new('revision-commit', MINGLE_SCHEME)
    
  end
end