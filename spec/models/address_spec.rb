require "spec_helper"

RSpec.describe KonturFocus::Models::Address do
  it "returns correct name" do
    hash = {
      "regionName" => {
        "topoShortName" => "обл",
        "topoFullName" => "область",
        "topoValue" => "Свердловская"
      },
      "city" => {
        "topoShortName" => "г",
        "topoFullName" => "город",
        "topoValue" => "Екатеринбург"
      },
      "street" => {
        "topoShortName" => "пр-кт",
        "topoFullName" => "проспект",
        "topoValue" => "Космонавтов"
      },
      "house" => {
        "topoShortName" => "дом",
        "topoFullName" => "дом",
        "topoValue" => "56"
      },
      "flat" => {
        "topoShortName" => "оф",
        "topoFullName" => "офис",
        "topoValue" => "17"
      }
    }

    address = KonturFocus::Models::Address.new(hash)
    expect(address.full_name).to eq("Свердловская область, город Екатеринбург, проспект Космонавтов, дом 56, офис 17")

    # Обратить внимание на отсутствие точек после двух видов сокращений:
    # пр-кт - в названии есть дефис
    # дом - не сокарщение
    expect(address.short_name).to eq("Свердловская обл., г. Екатеринбург, пр-кт Космонавтов, дом 56, оф. 17")
  end

  it "correct work if empty initializer" do
    address = KonturFocus::Models::Address.new(nil)
    expect(address.full_name).to eq("")
    address = KonturFocus::Models::Address.new({})
    expect(address.full_name).to eq("")
  end

  it "returns correct name with federal city" do
    hash = {
      "regionName" => {
        "topoShortName" => "г",
        "topoFullName" => "город",
        "topoValue" => "Москва"
      }
    }

    address = KonturFocus::Models::Address.new(hash)
    expect(address.full_name).to eq("город Москва")
    expect(address.short_name).to eq("г. Москва")
  end

  it "returns name with correct flat" do
    hash = {
      "house" => {
        "topoShortName" => "дом",
        "topoFullName" => "дом",
        "topoValue" => "26"
      },
      "flat" => {
        "topoValue" => "17"
      }
    }

    address = KonturFocus::Models::Address.new(hash)
    expect(address.full_name).to eq("дом 26, квартира 17")
    expect(address.short_name).to eq("дом 26, кв. 17")
  end
end
