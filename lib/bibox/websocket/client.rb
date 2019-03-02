module Bibox
  module Websocket
    # Websocket client for Bibox
    class Client
      attr_accessor :url, :prefix, :keepalive, :socket, :reactor_owner, :matchers, :callbacks
      
      def initialize(options: {})
        self.url          =   options.fetch(:url, "wss://push.bibox.com")
        self.prefix       =   options.fetch(:prefix, "bibox_sub_spot_")
        self.keepalive    =   options.fetch(:keepalive, false)
        
        self.matchers     =   {
          trading_pairs:          /\d?[A-Z]+_[A-Z]+_market/,
          order_book:             /\d?[A-Z]+_[A-Z]+_depth$/,
          trades:                 /\d?[A-Z]+_[A-Z]+_deals$/,
          ticker:                 /\d?[A-Z]+_[A-Z]+_ticker$/,
          klines:                 /\d?[A-Z]+_[A-Z]+_kline_(?<period>.*)$/,
          
          index_markets:          /\d?[A-Z]+_[A-Z]+_indexMarket/,
          contract_price_limits:  /\d?[A-Z]+_[A-Z]+_contractPriceLimit$/,
        }
        
        self.callbacks    =   {
          subscribe:              ->  { subscribe! },
          message:                ->  (data) { message(data) },
          trading_pairs:          ->  (data) { nil },
          order_book:             ->  (data) { nil },
          trades:                 ->  (data) { nil },
          ticker:                 ->  (data) { nil },
          klines:                 ->  (data) { nil },
          
          index_markets:          ->  (data) { nil },
          contract_price_limits:  ->  (data) { nil },
        }
      end

      def start!
        if EventMachine.reactor_running?
          self.reactor_owner    =   false
          refresh!
        else
          self.reactor_owner    =   true
          EM.run { refresh! }
        end
      end

      def stop!
        if self.reactor_owner == true
          self.socket.onclose   =   -> (_event) { EM.stop }
        else
          self.socket.onclose   =   -> (_event) { nil }
        end

        self.socket.close
      end

      def refresh!
        self.socket             =   Faye::WebSocket::Client.new(self.url)
        self.socket.onopen      =   method(:on_open)
        self.socket.onmessage   =   method(:on_message)
        self.socket.onclose     =   method(:on_close)
        self.socket.onerror     =   method(:on_error)
      end
      
      def login!
        subscribe_to! channel_name("ALL_ALL_login")
      end
      
      def subscribe_to_trading_pairs!
        subscribe_to! channel_name("ALL_ALL_market")
      end
      
      def subscribe_to_index_markets!
        subscribe_to! channel_name("ALL_ALL_indexMarket")
      end
      
      def subscribe_to_contract_price_limits!
        subscribe_to! channel_name("ALL_ALL_contractPriceLimit")
      end
      
      def subscribe_to_order_book!(pairs: [])
        pairs&.each { |pair| subscribe_to! channel_name("#{pair}_depth") }
      end
      
      def subscribe_to_trades!(pairs: [])
        pairs&.each { |pair| subscribe_to! channel_name("#{pair}_deals") }
      end
      
      def subscribe_to_ticker!(pairs: [])
        pairs&.each { |pair| subscribe_to! channel_name("#{pair}_ticker") }
      end
      
      def subscribe_to_klines!(pairs: [], periods: ["5min"])
        pairs&.each do |pair|
          periods&.each do |period|
            subscribe_to! channel_name("#{pair}_kline_#{period}")
          end
        end
      end
      
      def subscribe_to!(channel, binary: 0)
        message = { event: "addChannel", channel: channel, binary: binary }
        self.socket.send(message.to_json)
      end
      
      def channel_name(channel)
        "#{self.prefix}#{channel}"
      end

      def message(data)
        channel   =   data.fetch("channel", nil)&.gsub(self.prefix, "")
        
        case channel
          when self.matchers[:trading_pairs]
            self.callbacks[:trading_pairs].call(data)
          when self.matchers[:order_book]
            self.callbacks[:order_book].call(data)
          when self.matchers[:trades]
            self.callbacks[:trades].call(data)
          when self.matchers[:ticker]
            self.callbacks[:ticker].call(data)
          when self.matchers[:klines]
            period = channel.match(self.matchers[:klines])&.[](:period)
            data.merge!("period" => period) if !period.to_s.empty?
            self.callbacks[:klines].call(data)
          when self.matchers[:index_markets]
            self.callbacks[:index_markets].call(data)
          when self.matchers[:contract_price_limits]
            self.callbacks[:contract_price_limits].call(data)
        end
      end

      private
        def parse(data)
          return data if data.is_a? Hash
          return JSON.parse(data)
        rescue => err
          return data
        end
        
        def send_pong(timestamp)
          self.socket.send({pong: timestamp}.to_json)
        end

        def on_open(_event)
          self.callbacks[:subscribe].call
        end

        def on_message(event)
          parsed                =   parse(event.data)
          
          if parsed
            if parsed.is_a?(Hash)
              send_pong(parsed["ping"]) unless parsed.fetch("ping", nil).to_s.empty?
            elsif parsed.is_a?(Array)
              parsed            =   parsed.first
            end
            
            is_binary           =   parsed.fetch("binary", nil)&.eql?("1")

            if is_binary && !parsed.fetch("data", nil).to_s.empty?
              parsed["data"]    =   parse(Bibox::Utilities.decode_and_inflate(parsed["data"]))
            end
          
            self.callbacks[:message].call(parsed)
          end
        end

        def on_close(_event)
          if self.keepalive
            refresh!
          else
            EM.stop
          end
        end

        def on_error(event)
          raise ::Bibox::Errors::WebsocketError.new(event.message)
        end
    
    end
  end
end
