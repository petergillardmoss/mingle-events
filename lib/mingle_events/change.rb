module MingleEvents

  class Change

    # The change's old value
    attr_reader :old_value

    def initialize old_value=nil
      @old_value = old_value
    end

    def ==(other)
      other.is_a?(Change) && other.old_value == self.old_value
    end

    def hash
      term.hash ^ scheme.hash
    end

    def eql?(other)
      self == other
    end
  end
end
