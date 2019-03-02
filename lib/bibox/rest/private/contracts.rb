module Bibox
  module Rest
    module Private
      module Contracts
      
        def contracts(options: {})
          payload     =   [
            {
              cmd:  "query/contractValue",
              body: {}
            }
          ]
          
          response    =   parse(post("/cquery", data: payload, options: options))&.fetch("result", [])&.first&.fetch("result", [])
          
          raise response.inspect
        end
      
      end
    end
  end
end
