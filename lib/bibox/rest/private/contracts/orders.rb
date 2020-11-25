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
          
          def perform_contracts_order(pair:, options: {})
            params      =   {
              pair:           pair,
              order_type:     Bibox::Models::Order::ORDER_TYPES[order_type],
              order_side:     Bibox::Models::Order::ORDER_SIDES[order_side],
              pay_bix:        pay_fees_with_bix.eql?(true) ? 1 : 0,
              price:          price,
              amount:         amount,
              money:          (price * amount),
            }
          
            payload     =   [
              {
                cmd:  "order/open",
                body: params
              }
            ]
          
            response    =   parse(post("/ctrade", data: payload, options: options))&.fetch("result", [])&.first&.fetch("result", {})
          end
          
        end
      end
    end
  end
end
