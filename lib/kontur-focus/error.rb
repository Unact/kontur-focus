# Ошибки, полученные от Контура, наследуются от KonturFocus::Error
# В остальных случаях выбрасываются RuntimeError
module KonturFocus
  class Error < ::StandardError
    extend Forwardable

    def_delegators :@response, :status, :body, :uri

    def initialize response
      @response = response
    end

    def to_s
      <<~eos
        Произошла ошибка при интеграции c Контур.Фокус
        - Status: #{status}
        - Body: #{body}
        - URL: #{uri}
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
