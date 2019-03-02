# Rest API
require "faraday"
require "faraday_middleware"
require "openssl"

# Websockets
require "faye/websocket"
require "eventmachine"

# Parsing / Decoding
require "zlib"
require "stringio"
require "base64"

# Shared
require "json"
require "date"
require "bigdecimal"

# Library
require "bibox/version"

require "bibox/configuration"
require "bibox/errors"
require "bibox/constants"
require "bibox/utilities"

require "bibox/models/base"
require "bibox/models/ticker"
require "bibox/models/pair"
require "bibox/models/trade"
require "bibox/models/order_book"
require "bibox/models/ohlcv"
require "bibox/models/order"
require "bibox/models/asset"
require "bibox/models/user_assets"
require "bibox/models/transfer"
require "bibox/models/bill"
require "bibox/models/contract"

require "bibox/rest/public/ticker"
require "bibox/rest/public/pairs"
require "bibox/rest/public/trades"
require "bibox/rest/public/order_book"
require "bibox/rest/public/klines"

require "bibox/rest/private/orders"
require "bibox/rest/private/order_book"
require "bibox/rest/private/contracts"
require "bibox/rest/private/assets"
require "bibox/rest/private/transfers"
require "bibox/rest/private/bills"

require "bibox/rest/errors"
require "bibox/rest/client"

require "bibox/websocket/client"

if !String.instance_methods(false).include?(:underscore)
  require "bibox/extensions/string"
end

module Bibox
  
  class << self
    attr_writer :configuration
  end
  
  def self.configuration
    @configuration ||= ::Bibox::Configuration.new
  end

  def self.reset
    @configuration = ::Bibox::Configuration.new
  end

  def self.configure
    yield(configuration)
  end

end
