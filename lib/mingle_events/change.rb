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

  class Change
    include ValueChange

    # The change's new value
    attr_reader :change_type

    def initialize change_type, old_value, new_value
      @change_type = change_type
      super old_value, new_value
    end

    def ==(other)
      other.is_a?(Change) && other.change_type == self.change_type && same_values_as(other)
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
      other.is_a?(PropertyChange) && same_values_as(other)
    end

    def hash
      term.hash ^ scheme.hash
    end

    def eql?(other)
      self == other
    end

  end
end
