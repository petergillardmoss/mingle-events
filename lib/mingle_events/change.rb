module MingleEvents

  class Change

    # The change's old value
    attr_reader :old_value

    # The change's new value
    attr_reader :new_value

    def initialize old_value=nil, new_value=nil
      @old_value = old_value
      @new_value = new_value
    end

    def ==(other)
      other.is_a?(Change) && other.old_value == self.old_value && other.new_value == self.new_value
    end

    def hash
      term.hash ^ scheme.hash
    end

    def eql?(other)
      self == other
    end
  end
end
