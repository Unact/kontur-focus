module KonturFocus::Models
  class Ul < Organization
    attr_reader :kpp

    def initialize hash
      super hash

      @kpp = hash["UL"]["kpp"]
      @address = Address.new(hash["UL"]["legalAddress"]["parsedAddressRF"])
    end

    def ip?; false; end

    def full_address; @address.full_name; end
    def short_address; @address.short_name; end
  end
end
