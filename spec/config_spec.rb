require "spec_helper"

RSpec.describe KonturFocus::Config do
  it 'shoud return correct default value' do
    # Зануллить конфигурацию, что бы применялись значения по умолчанию.
    # Надо на тут случай, если этот тест выполняется после других тестов
    # в которых изменяется конaфигурация
    KonturFocus.configure do |config|
      config.key = nil
      config.version = nil
    end
    ENV["KONTUR_FOCUS_KEY"] = 'key_from_env'

    expect(KonturFocus.config.key).to eq('key_from_env')
    expect(KonturFocus.config.version).to eq('3')
  end

  it 'shoud correct set up value' do
    KonturFocus.configure do |config|
      config.key = 'key_form_config'
      config.version = '4'
    end

    expect(KonturFocus.config.key).to eq('key_form_config')
    expect(KonturFocus.config.version).to eq('4')
  end
end
