module MingleEvents
  class Change
    def ==(other)
      other.is_a?(Change)
    end

    def hash
      term.hash ^ scheme.hash
    end

    def eql?(other)
      self == other
    end
  end
end
