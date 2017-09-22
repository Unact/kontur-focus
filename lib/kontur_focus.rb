require "kontur_focus/version"
require "kontur_focus/config"
require "kontur_focus/api3"
require "kontur_focus/error"
require "kontur_focus/utils"
require "kontur_focus/models"
require "http"

module KonturFocus
  def self.configure
    reset_api
    yield Config.instance
  end

  def self.config
    return Config.instance
  end

  def self.api
    return @api if @api
    if config.version.to_s == Api3::API_SHORT_VERSION
      @api = Api3.new
      return @api
    end
    raise 'Выбрана не поддерживаемая версия api (см KonturFocus.configure do |config| config.version = <Значение>)'
  end

  private
    def self.reset_api
      @api = nil
    end
end
