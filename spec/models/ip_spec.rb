require "spec_helper"

RSpec.describe KonturFocus::Models::Ip do
  it 'organization correct produce ip' do
    ip = KonturFocus::Models::Organization.produce(read_data("561100409545.json"))

    expect(ip.ip?).to be true
    expect(ip.ul?).to be false
    expect(ip.registration_date).to eq "2009-03-27"
    expect(ip.dissolution_date).to eq "2018-01-02"
  end
end
