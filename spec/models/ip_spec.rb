require "spec_helper"

RSpec.describe KonturFocus::Models::Ip do
  it 'organization correct produce ip' do
    hash = JSON.parse(File.read 'spec/data/561100409545.json').first
    ip = KonturFocus::Models::Organization.produce(hash)

    expect(ip.ip?).to be true
    expect(ip.ul?).to be false
  end
end
