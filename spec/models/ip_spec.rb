require "spec_helper"

RSpec.describe KonturFocus::Models::Ip do
  it 'organization correct produce ip' do
    ip = KonturFocus::Models::Organization.produce(read_data("561100409545.json"))

    expect(ip.ip?).to be true
    expect(ip.ul?).to be false
  end
end
