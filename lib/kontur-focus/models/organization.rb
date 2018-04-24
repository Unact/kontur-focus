module KonturFocus::Models
  class Organization
    attr_reader :inn, :ogrn, :focus_href, :brief_report, :contact_phones, :dissolution_date, :registration_date

    class << self
      protected :new

      def produce hash
        if hash.has_key? "IP"
          Ip.new(hash)
        elsif hash.has_key? "UL"
          Ul.new(hash)
        else
          raise "Тип организации не определен"
        end
      end
    end

    def initialize hash
      @inn = hash["inn"]
      @ogrn = hash["ogrn"]
      @focus_href = hash["focusHref"]
      @brief_report = hash["briefReport"]
      @contact_phones = hash["contactPhones"]
      @registration_date = nil
      @dissolution_date = nil
      @hash = hash
    end

    def ip?; raise NotImplementedError; end
    def ul?; not ip? end

    def to_json
      @hash.to_json
    end

    def to_xml options={}
      options = {root: :req, skip_types: true}.merge options
      @hash.to_xml options
    end
  end
end
