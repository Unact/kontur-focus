module KonturFocus::Models
  class Address
    ADDRESS_PARTS = ["zipCode", "regionName", "district", "city", "settlement", "street", "house", "bulk", "flat"]
    SEPARATOR = ", "

    def initialize hash
      @address_parts = ADDRESS_PARTS.map do |topo_type|
        AddressPart.produce(topo_type, hash[topo_type]) if hash&.has_key? topo_type
      end.compact
    end

    def full_name
      @address_parts.map{|address_part| address_part.full_name}.join(SEPARATOR)
    end

    def short_name
      @address_parts.map{|address_part| address_part.short_name}.join(SEPARATOR)
    end

    class AddressPart
      REVERSE_PARTS = ["regionName", "district"]
      DIRECT_PARTS = Address::ADDRESS_PARTS - REVERSE_PARTS

      class << self
        protected :new

        def produce topo_type, hash
          case topo_type
            when "regionName" then Region.new topo_type, hash
            when "flat" then Flat.new topo_type, hash
            when "zipCode" then ZipCode.new topo_type, hash
            else self.new topo_type, hash
          end
        end
      end

      def initialize topo_type, hash
        @topo_type = topo_type
        @topo_full_name = hash["topoFullName"]
        @topo_short_name = hash["topoShortName"]
        @topo_value = hash["topoValue"]

        if (@topo_short_name != @topo_full_name) && !@topo_short_name.include?('-')
          @topo_short_name = "#{@topo_short_name}."
        end
      end

      def full_name
        send "#{direction}_full_name"
      end

      def short_name
        send "#{direction}_short_name"
      end

      private
        def direction
          if REVERSE_PARTS.include? @topo_type
            :reverse
          elsif DIRECT_PARTS.include? @topo_type
            :direct
          else
            raise "Неподдерживаемый аргумент"
          end
        end

        def direct_full_name;   "#{@topo_full_name} #{@topo_value}";  end
        def direct_short_name;  "#{@topo_short_name} #{@topo_value}"; end
        def reverse_full_name;  "#{@topo_value} #{@topo_full_name}";  end
        def reverse_short_name; "#{@topo_value} #{@topo_short_name}"; end
    end

    class ZipCode < AddressPart
      def initialize _, value; @value = value; end

      def full_name;  @value; end
      def short_name; @value; end
    end

    class Region < AddressPart
      private
        def direction
          if @topo_full_name == 'город'
            :direct
          else
            super
          end
        end
    end

    class Flat < AddressPart
      def initialize topo_type, hash
        hash_dup = hash.dup
        if hash["topoFullName"].nil? && hash["topoShortName"].nil?
          hash_dup["topoFullName"] = "квартира"
          hash_dup["topoShortName"] = "кв"
        end

        super topo_type, hash_dup
      end
    end
  end
end
