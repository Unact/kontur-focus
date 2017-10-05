require 'singleton'

module KonturFocus
  class Config
    include Singleton

    attr_writer :key, :version

    def key
      @key || ENV["KONTUR_FOCUS_KEY"]
    end

    def version
      @version || Api3::API_SHORT_VERSION
    end
  end
end
