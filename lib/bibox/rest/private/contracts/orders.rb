module Bibox
  module Rest
    module Private
      module Contracts
        module Orders
          
          def contract_orders(pair:, options: {})
            payload     =   [
              {
                cmd:  "query/order",
                body: {
                  pair: pair
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
