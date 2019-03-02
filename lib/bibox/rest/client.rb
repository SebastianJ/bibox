module Bibox
  module Rest
    class Client
      attr_accessor :url, :configuration
      
      def initialize(configuration: ::Bibox.configuration)
        self.url              =   "https://api.bibox.com/v1"
        self.configuration    =   configuration
      end
      
      include ::Bibox::Rest::Errors
      
      include ::Bibox::Rest::Public::Ticker
      include ::Bibox::Rest::Public::Pairs
      include ::Bibox::Rest::Public::Trades
      include ::Bibox::Rest::Public::OrderBook
      include ::Bibox::Rest::Public::Klines
      
      include ::Bibox::Rest::Private::Orders
      include ::Bibox::Rest::Private::OrderBook
      include ::Bibox::Rest::Private::Assets
      include ::Bibox::Rest::Private::Transfers
      include ::Bibox::Rest::Private::Bills
      
      include ::Bibox::Rest::Private::Contracts::General
      include ::Bibox::Rest::Private::Contracts::Assets
      include ::Bibox::Rest::Private::Contracts::Orders
            
      def configured?
        !self.configuration.key.to_s.empty? && !self.configuration.secret.to_s.empty?
      end

      def check_credentials!
        unless configured?
          raise ::Bibox::Errors::MissingConfigError.new("Bibox gem hasn't been properly configured.")
        end
      end
      
      def to_uri(path)
        "#{self.url}#{path}"
      end
      
      def parse(response)
        error?(response)
        response
      end

      def get(path, params: {}, options: {})
        request path, method: :get, params: params, options: options
      end

      def post(path, params: {}, data: {}, options: {})
        request path, method: :post, params: params, data: auth(data), options: options
      end

      def auth(payload = {})
        data              =   {}
        data[:cmds]       =   payload.to_json
        
        if configured?
          data[:apikey]   =   self.configuration.key
          data[:sign]     =   ::OpenSSL::HMAC.hexdigest('md5', self.configuration.secret, payload.to_json)
        end
        
        return data
      end

      def request(path, method: :get, params: {}, data: {}, options: {})
        user_agent    =   options.fetch(:user_agent, self.configuration.faraday.fetch(:user_agent, nil))
        proxy         =   options.fetch(:proxy, nil)
    
        connection    =   Faraday.new(url: to_uri(path)) do |builder|
          builder.headers[:user_agent] = user_agent if !user_agent.to_s.empty?
          builder.request  :url_encoded if method.eql?(:post)
          builder.response :logger      if self.configuration.verbose_faraday?
          builder.response :json
      
          if proxy
            puts "[Bibox::Rest::Client] - Will connect to Bibox using proxy: #{proxy.inspect}" if self.configuration.verbose_faraday?
            builder.proxy = proxy
          end
      
          builder.adapter self.configuration.faraday.fetch(:adapter, :net_http)
        end
    
        case method
          when :get
            connection.get do |request|
              request.params  =   params if params && !params.empty?
            end&.body
          when :post
            connection.post do |request|
              request.body    =   data
              request.params  =   params if params && !params.empty?
            end&.body
        end
      end
            
    end
  end  
end
