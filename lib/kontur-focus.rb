require "kontur-focus/version"
require "kontur-focus/config"
require "kontur-focus/api3"
require "kontur-focus/error"
require "kontur-focus/utils"
require "kontur-focus/models"
require "http"
require "active_support"
require "active_support/core_ext"

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
