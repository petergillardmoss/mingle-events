module MingleEvents

  module ValueChange
    # The change's old value
    attr_reader :old_value

    # The change's new value
    attr_reader :new_value

    def initialize old_value, new_value
      @old_value = old_value
      @new_value = new_value
    end

    def same_values_as(other)
      other.old_value == self.old_value && other.new_value == self.new_value
    end
  end

  class NameChange
    include ValueChange

    def initialize old_value, new_value
      super old_value, new_value
    end

    def ==(other)
      other.is_a?(NameChange) && same_values_as(other)
    end

    def hash
      term.hash ^ scheme.hash
    end

    def eql?(other)
      self == other
    end
  end

  class PropertyChange
    include ValueChange

    # The name of the property
    attr_reader :name

    def initialize old_value, new_value, name
      @name = name
      super old_value, new_value
    end

    def ==(other)
      other.is_a?(PropertyChange) && same_values_as(other) && self.name == other.name
    end

    def hash
      term.hash ^ scheme.hash
    end

    def eql?(other)
      self == other
    end

  end

  class SimpleChange
    def ==(other)
      other.is_a?(self.class)
    end

    def hash
      term.hash ^ scheme.hash
    end

    def eql?(other)
      self == other
    end
  end

  class CardCreationChange < SimpleChange
  end

  class CardDeletionChange < SimpleChange
  end

  class DescriptionChange < SimpleChange
  end

  class CommentAdditionChange
    # The comment added
    attr_reader :comment

    def initialize comment=nil
      @comment = comment
    end

    def ==(other)
      other.is_a?(self.class) && self.comment == other.comment
    end

    def hash
      term.hash ^ scheme.hash
    end

    def eql?(other)
      self == other
    end
  end
end
