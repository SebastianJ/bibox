module Bibox
  module Rest
    module Private
      module Contracts
        module General
          def contract_values(options: {})
            payload     =   [
              {
                cmd:  "query/contractValue",
                body: {}
              }
            ]
          
            response    =   post("/cquery", data: payload, options: options)#&.fetch("result", [])&.first&.fetch("result", [])
          
            raise response.inspect
          end
        end
      end
    end
  end
end
