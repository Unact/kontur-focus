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
      }
    }

    address = KonturFocus::Models::Address.new(hash)
    expect(address.full_name).to eq("Свердловская область, город Екатеринбург, проспект Космонавтов, дом 56")
    expect(address.short_name).to eq("Свердловская обл, г Екатеринбург, пр-кт Космонавтов, дом 56")
  end

  it "correct work if empty initializer" do
    address = KonturFocus::Models::Address.new(nil)
    expect(address.full_name).to eq("")
    address = KonturFocus::Models::Address.new({})
    expect(address.full_name).to eq("")
  end
end
