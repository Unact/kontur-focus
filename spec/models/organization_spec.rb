require "spec_helper"

RSpec.describe KonturFocus::Models::Organization do
  it 'correct parce hash to object' do
    hash = JSON.parse(File.read 'spec/data/6663003127.json').first
    org = KonturFocus::Models::Organization.produce(hash)

    expect(org.inn).to eq "6663003127"
    expect(org.ogrn).to eq "1026605606620"
    expect(org.focus_href).to eq "https:\/\/focus.kontur.ru\/entity?query=1026605606620"
    expect(org.brief_report).to eq({"summary" => {"greenStatements" => true}})
    expect(org.contact_phones).to eq({"count" => 47})
    expect(JSON.parse(org.to_json)).to eq(hash)
  end
end
