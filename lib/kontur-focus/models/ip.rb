module KonturFocus::Models
  class Ip < Organization
    def initialize hash
      super hash
      @registration_date = hash["IP"]["registrationDate"]
      @dissolution_date = hash["IP"]["dissolutionDate"]
    end

    def ip?; true; end
  end
end
