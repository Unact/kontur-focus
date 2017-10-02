module KonturFocus::Models
  class Address
    ADDRESS_PARTS = ["regionName", "district", "city", "settlement", "street", "house", "bulk", "flat"]
    SEPORATOR = ", "

    def initialize hash
      @address_parts = ADDRESS_PARTS.map do |topo_type|
        AddressPart.new(topo_type, hash[topo_type]) if hash&.has_key? topo_type
      end.compact
    end

    def full_name
      @address_parts.map{|address_part| address_part.full_name}.join(SEPORATOR)
    end

    def short_name
      @address_parts.map{|address_part| address_part.short_name}.join(SEPORATOR)
    end

    class AddressPart
      REVERSE_PARTS = ["regionName", "district"]
      DIRECT_PARTS = Address::ADDRESS_PARTS - REVERSE_PARTS

      def initialize topo_type, hash
        @topo_type = topo_type
        @topo_full_name = hash["topoFullName"]
        @topo_short_name = hash["topoShortName"]
        @topo_value = hash["topoValue"]
      end

      def full_name
        send "#{self.class.direction @topo_type}_full_name"
      end

      def short_name
        send "#{self.class.direction @topo_type}_short_name"
      end

      def self.direction topo_type
        if REVERSE_PARTS.include? topo_type
          :reverse
        elsif DIRECT_PARTS.include? topo_type
          :direct
        else
          raise "Неподдерживаемый аргумент"
        end
      end

      private
        def direct_full_name;   "#{@topo_full_name} #{@topo_value}";  end
        def direct_short_name;  "#{@topo_short_name} #{@topo_value}"; end
        def reverse_full_name;  "#{@topo_value} #{@topo_full_name}";  end
        def reverse_short_name; "#{@topo_value} #{@topo_short_name}"; end
    end
  end
end
