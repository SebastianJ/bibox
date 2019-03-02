module Bibox
  module Models
    class Contract < Base
      MAPPING   =   {
        id:             :integer,
        pair:           :string,
        value:          :float,
        coin_symbol:    :string,
        
        offset_normal:  :float,
        offset_short:   :float,
        offset_long:    :float,
        normal_dx:      :float,
        
        created_at:     :datetime,
        updated_at:     :datetime
      }
    end
  end
end
