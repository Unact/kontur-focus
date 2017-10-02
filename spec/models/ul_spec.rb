require "spec_helper"

RSpec.describe KonturFocus::Models::Ul do
  it 'organization correct produce ul' do
    ul = KonturFocus::Models::Organization.produce(read_data("6663003127.json"))

    expect(ul.ip?).to be false
    expect(ul.ul?).to be true

    expect(ul.kpp).to eq "668601001"
    expect(ul.full_address).to eq "Свердловская область, город Екатеринбург, проспект Космонавтов, дом 56"
    expect(ul.short_address).to eq "Свердловская обл, г Екатеринбург, пр-кт Космонавтов, дом 56"
  end
end
