module Bibox
  module Models
    class Transfer < Base
      MAPPING  =   {
        user_id:        :string,
        coin_id:        :string,
        to:             :string,
        coin_symbol:    :string,
        confirm_count:  :string,
        amount:         :float,
        updated_at:     :time,
        created_at:     :time,
        url:            :string,
        icon_url:       :string,
        status:         {enum: {1 => :pending, 2 => :success, 3 => :failed}},
      }
      
      STATUSES     =   {
        all:      0,
        pending:  1,
        success:  2,
        failed:   3
      }
    end
  end
end
