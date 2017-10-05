module KonturFocus::Models
  class Ip < Organization
    def initialize hash
      super hash
    end

    def ip?; true; end
  end
end
