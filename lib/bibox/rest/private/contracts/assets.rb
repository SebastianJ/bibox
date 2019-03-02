module Bibox
  module Rest
    module Private
      module Contracts
        module Assets
          
          def contract_assets(coin_symbol: "USDT", options: {})
            payload     =   [
              {
                cmd:  "query/assets",
                body: {
                  coin_symbol: coin_symbol
                }
              }
            ]
          
            response    =   parse(post("/cquery", data: payload, options: options))&.fetch("result", [])&.first&.fetch("result", [])
          end
          
        end
      end
    end
  end
end
