# https://focus-api.kontur.ru/api3/index.html
module KonturFocus
  class Api3
    SEPORATOR = ','
    API_URL = "https://focus-api.kontur.ru"
    API_VERSION = "api3"
    API_SHORT_VERSION = "3"
    MAX_INN_OR_ORGN = 100

    def req inn_or_inns, orgn_or_ogrns=nil
      response = [*req_inns(inn_or_inns), *req_ogrns(orgn_or_ogrns)]
      response.map{|hash| KonturFocus::Models::Organization.produce(hash)}
    end

    def stat
      send_request do |params|
        HTTP.get(build_url("stat"), params: params)
      end
    end

    def mon date = Date.today
      send_request do |params|
        params["date"] = date.strftime("%Y-%m-%d")

        HTTP.get(build_url("mon"), params: params)
      end
    end

    # Описание из Контура:
    # Указать список организаций для наблюдения за изменениями
    #
    # Метод возвращает подмножество (ИНН или ОГРН), состоящее из элементов параметра, которых нет в Контуре
    def mon_list inn_or_inns_or_ogrn_or_ogrns
      monitoring = [*inn_or_inns_or_ogrn_or_ogrns]
      responce = send_request do |params|
        HTTP.post(build_url("monList"), params: params, body: monitoring.join(SEPORATOR))
      end

      Utils.diff(monitoring, responce)
    end

    private
      def build_url api_method
        "#{API_URL}/#{API_VERSION}/#{api_method}"
      end

      def send_request params={}
        responce = yield(apply_default_params params)
        resolve_api_error responce unless responce.code == 200
        parse_response responce
      end

      def req_inns inn_or_inns
        req_generic :inn, inn_or_inns
      end

      def req_ogrns orgn_or_ogrns
        req_generic :ogrn, orgn_or_ogrns
      end

      # param_name - принимает значения inn или ogrn.
      # param_value_or_values - одно значение или массив значений.
      # Массив значений посылается порциями (по MAX_INN_OR_ORGN значений)
      #
      # Контур ведет себя немного странно:
      # Если передать существующий ИНН, а вместе с ним не валидный ИНН, то контур вернет информацию
      # только о корректном ИНН
      # Если передать только невалидный ИНН, то Контур вернет ошибку "inn/ogrn param is not specified"
      # Что неожиданно. Эту ошибку не будем выбрасывать наружу, а обратоем, как пустой массив
      def req_generic param_name, param_value_or_values
        param_values = [*param_value_or_values]
        if param_values.length > 0

          # Простая проверка, что ИНН/ОГРН - это вообще-то числа.
          # Но преобразовывать в числа не будем, т.к. могут встретиться ведущие нули (если могут, конечно).
          incorrect_value = param_values.find{|value| /\D/ =~ value.to_s}
          raise "Введен неверный параметр #{incorrect_value}" if incorrect_value

          param_values.each_slice(MAX_INN_OR_ORGN).reduce([]) do |memo, values|
            begin
              memo + send_request do |params|
                params[param_name] = values.join(SEPORATOR)
                HTTP.get(build_url("req"), params: params)
              end
            rescue InnOrgnParamIsNotSpecifiedError
              memo
            end
          end
        end
      end

      def apply_default_params params={}
        {key: KonturFocus.config.key}.merge params
      end

      def parse_response responce
        responce.parse # Работает только если Content-type - application/json. Нас это устраивает
      end

      def resolve_api_error responce
        ErrorFabric.produce responce
      end
  end
end
