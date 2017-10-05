module KonturFocus
  class Error < StandardError
    def initialize response
      @response = response
    end

    def to_s
      <<~eos
        Произошла ошибка при интеграции c Контур.Фокус
        - Status: #{@response.status}
        - Body: #{@response.body}
        - URL: #{@response.uri}
      eos
    end
  end

  class InnOrgnParamIsNotSpecifiedError < Error
  end

  class NoValidKeySpecifiedError < Error
  end

  class ErrorFabric
    def self.produce response
      return if response.code == 200
      if response.code == 400 && response.body.to_s == "inn/ogrn param is not specified"
        raise InnOrgnParamIsNotSpecifiedError.new response
      elsif response.code == 403 && response.body.to_s == "No valid key specified"
        raise NoValidKeySpecifiedError.new response
      end
      raise Error.new response
    end
  end
end
