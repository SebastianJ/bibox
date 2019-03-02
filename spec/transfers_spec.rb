require 'spec_helper'

describe Bibox::Rest::Client do
  before { setup_bibox }
  let(:client) { Bibox::Rest::Client.new }
  
  describe :deposits, vcr: {cassette_name: 'bibox/transfers/deposit_address'} do
    let(:address) { client.deposit_address("BTC") }
    
    it { expect(address).to be_a_kind_of String }
    it { expect(address).to eq "MASKED_BTC_ADDRESS" }
  end
  
  describe :deposits, vcr: {cassette_name: 'bibox/transfers/deposits'} do
    let(:deposits) { client.deposits }
    let(:deposit) { deposits.first }
    
    it { expect(deposits).to be_a_kind_of Array }
    it { expect(deposits.count).to eq 2 }
    
    expectations = {
      user_id:        "MASKED_USER_ID",
      coin_id:        "44",
      to:             "MASKED_ADDRESS",
      coin_symbol:    "ETH",
      confirm_count:  "14+",
      amount:         1.0,
      updated_at:     DateTime.new(2019, 03, 02, 9, 13, 1).to_time,
      created_at:     DateTime.new(2019, 03, 02, 9, 13, 1).to_time,
      url:            "https://www.etherscan.io/tx/MASKED_TX",
      icon_url:       "https://res.linkcoin.pro/coinicon/ETH.png",
      status:         :success
    }

    it { expect(deposit).to be_a_kind_of(::Bibox::Models::Transfer) }
  
    expectations.each do |key, value|
      it "should have correct value for instance variable #{key}" do
        expect(deposit.send(key)).to eq value
      end
    end
  end
  
  # Create test case for withdrawals when there are withdrawals to test against
  
end
