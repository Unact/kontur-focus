require "spec_helper"

RSpec.describe KonturFocus do
  it "has a version number" do
    expect(KonturFocus::VERSION).not_to be nil
  end

  it "shoud return corresponding version of api" do
    KonturFocus.configure do |config|
      config.version = '3'
    end

    expect(KonturFocus.api).to be_an_instance_of KonturFocus::Api3
  end

  it "shoud raise error if corresponding version of api not supported" do
    KonturFocus.configure do |config|
      config.version = '1'
    end

    expect{KonturFocus.api}.to raise_error(
      "Выбрана не поддерживаемая версия api (см KonturFocus.configure do |config| config.version = <Значение>)"
    )
  end
end
