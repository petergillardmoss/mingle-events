module MingleEvents

  class Change

    # The change's old value
    attr_reader :old_value

    # The change's new value
    attr_reader :new_value

    # The change's new value
    attr_reader :change_type

    def initialize change_type, old_value, new_value
      @change_type = change_type
      @old_value = old_value
      @new_value = new_value
    end

    def ==(other)
      other.is_a?(Change) && other.old_value == self.old_value && other.new_value == self.new_value && other.change_type == self.change_type
    end

    def hash
      term.hash ^ scheme.hash
    end

    def eql?(other)
      self == other
    end
  end

  class PropertyChange
    # The change's old value
    attr_reader :old_value

    # The change's new value
    attr_reader :new_value

    def initialize old_value, new_value
      @old_value = old_value
      @new_value = new_value
    end

    def ==(other)
      other.is_a?(PropertyChange) && other.old_value == self.old_value && other.new_value == self.new_value
    end

    def hash
      term.hash ^ scheme.hash
    end

    def eql?(other)
      self == other
    end

  end
end
