require "spec_helper"

RSpec.describe KonturFocus::Api3 do
  context "method 'req'" do
    it "returns UL or IP if params contain inn or ogrn" do
      KonturFocus.configure do |config|
        config.key = "secret_key"
        config.version = "3"
      end

      stub_request(:get, "https://focus-api.kontur.ru/api3/req").
        with(query: {key: 'secret_key', inn: '6663003127'}).
        to_return ({
          body: File.new("spec/data/6663003127.json"),
          status: 200,
          headers: { "Content-Type" => "application/json" }
        })

      organizations = KonturFocus.api.req("6663003127")
      ul = organizations.first
      expect(ul.ul?).to be true

      organizations = KonturFocus.api.req(6663003127)
      ul = organizations.first
      expect(ul.ul?).to be true

      organizations = KonturFocus.api.req(["6663003127"])
      ul = organizations.first
      expect(ul.ul?).to be true

      organizations = KonturFocus.api.req([6663003127])
      ul = organizations.first
      expect(ul.ul?).to be true
    end

    it "returns exeption if param can not convert to int" do
      KonturFocus.configure do |config|
        config.version = "3"
      end

      expect{KonturFocus.api.req("1234,5678")}.to raise_error "Введен неверный параметр 1234,5678"
    end

    it "returns empty array without get request if params is empty" do
      WebMock.disable_net_connect! # Если запрос отправится, то вернется исключение

      KonturFocus.configure do |config|
        config.key = "secret_key"
        config.version = "3"
      end

      result = KonturFocus.api.req(nil)
      expect(result).to match_array([])

      result = KonturFocus.api.req([])
      expect(result).to match_array([])
    end

    it "returns empty array if params is not valie" do
      KonturFocus.configure do |config|
        config.key = "secret_key"
        config.version = "3"
      end

      stub_request(:get, "https://focus-api.kontur.ru/api3/req").
        with(query: {key: 'secret_key',inn: '00000'}).
        to_return ({
          body: "inn/ogrn param is not specified",
          status: 400,
          headers: { "Content-Type" => "text/plain; charset=utf-8" }
        })

      result = KonturFocus.api.req(['00000'])

      expect(result).to match_array([])
    end

    it "raises error if param key not specified" do
      KonturFocus.configure do |config|
        config.key = ""
        config.version = "3"
      end

      stub_request(:get, "https://focus-api.kontur.ru/api3/req").
        with(query: {key: "", inn: '6663003127'}).
        to_return ({
          body: "No valid key specified",
          status: 403,
          headers: { "Content-Type" => "text/plain; charset=utf-8" }
        })

      expect{KonturFocus.api.req(['6663003127'])}.to raise_error(KonturFocus::NoValidKeySpecifiedError)
    end

    it "splits long parmas" do
      KonturFocus.configure do |config|
        config.key = "secret_key"
        config.version = "3"
      end

      inn_batches = [(1..100).to_a, (101..200).to_a, (201..250).to_a]
      orgn_batches = [(1..100).to_a, (101..200).to_a, (201..250).to_a]

      inns = inn_batches.flatten
      ogrns = orgn_batches.flatten

      # (!) Задаем разрешенные запросы, а не порядок следования
      inn_batches.each do |inn_batch|
        stub_request(:get, "https://focus-api.kontur.ru/api3/req").
          with(query: {key: "secret_key", inn: inn_batch.join(',')}).
          to_return ({
            body: "[]",
            status: 200,
            headers: { "Content-Type" => "application/json" }
          })
      end

      orgn_batches.each do |orgn_batch|
        stub_request(:get, "https://focus-api.kontur.ru/api3/req").
          with(query: {key: "secret_key", ogrn: orgn_batch.join(',')}).
          to_return ({
            body: "[]", # тут будет реальный объект
            status: 200,
            headers: { "Content-Type" => "application/json" }
          })
      end

      KonturFocus.api.req(inns, ogrns)
    end
  end



  context "method 'stat'" do
    it 'returns statistics' do
      KonturFocus.configure do |config|
        config.key = "secret_key"
        config.version = "3"
      end

      stub_request(:get, "https://focus-api.kontur.ru/api3/stat").
        with(query: {key: 'secret_key'}).
        to_return ({
          body: "[{}]",
          status: 200,
          headers: { "Content-Type" => "application/json" }
        })

      KonturFocus.api.stat
    end
  end

  context "method 'stat'" do
    it 'returns statistics' do
      KonturFocus.configure do |config|
        config.key = "secret_key"
        config.version = "3"
      end

      stub_request(:get, "https://focus-api.kontur.ru/api3/stat").
        with(query: {key: 'secret_key'}).
        to_return ({
          body: "[{}]",
          status: 200,
          headers: { "Content-Type" => "application/json" }
        })

      KonturFocus.api.stat
    end
  end

  context "method 'mon_list'" do
    it 'returns subset of params if same params do not exist in Kontur' do
      KonturFocus.configure do |config|
        config.key = "secret_key"
        config.version = "3"
      end

      inns_or_orgns = [1, 1, 2, 3, '4', '5', 5]

      stub_request(:post, "https://focus-api.kontur.ru/api3/monList").
        with(query: {key: 'secret_key'}, body: inns_or_orgns.join(',')).
        to_return ({
          body: '[
            {"inn": "1", "ogrn": "999999"},
            {"inn": "2", "ogrn": "999998"},
            {"inn": "1111111", "ogrn": "4"}
          ]',
          status: 200,
          headers: { "Content-Type" => "application/json" }
        })
      expect(KonturFocus.api.mon_list inns_or_orgns).to match_array([3,5])
    end
  end

  context "method 'mon'" do
    it 'returns orgns if something changed' do
      KonturFocus.configure do |config|
        config.key = "secret_key"
        config.version = "3"
      end

      stub_request(:get, "https://focus-api.kontur.ru/api3/mon").
        with(query: {key: 'secret_key', date: '2017-09-01'}).
        to_return({
          body: "[{}]",
          status: 200,
          headers: { "Content-Type" => "application/json" }
        })

      KonturFocus.api.mon Date.new(2017,9,1)
    end
  end
end
