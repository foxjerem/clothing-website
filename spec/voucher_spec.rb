require 'voucher'

describe Voucher do   

  let(:voucher)         { Voucher.new(0, 5.0, 'always')                                           }
  let(:big_voucher)     { Voucher.new(1, 10, 'when you spend more than £10','total > 10')         }
  let(:complex_voucher) { Voucher.new(2, 15, 'Big spender', 'total > 75', 'has_footwear_item?')   }
  let(:cart)            { double ShoppingCart, total: 80, :has_footwear_item? => false            }

  context 'intialisation' do
    
    it 'should have an id' do
      expect(voucher.id).to eq 0
    end

    it 'should have a discount' do
      expect(voucher.discount).to eq 5.0
    end
    
    it 'should have conditions' do
      expect(big_voucher.conditions).to eq ['total > 10']
    end

    it 'should have a description' do
      expect(big_voucher.description).to eq 'when you spend more than £10'
    end

  end

  context '#valid_for' do

    it 'should know if a voucher is valid for a given shopping cart' do
      expect(big_voucher.valid_for?(cart)).to be true
    end

    it 'should know if a voucher is not valid for a given shopping cart' do
      complex_voucher = Voucher.new(2, 15, 'Big spender', 'total > 75', 'has_footwear_item?')
      expect(complex_voucher.valid_for?(cart)).to be false
    end

  end

  context '#apply_to' do

    before(:each) { allow(cart).to receive(:discount).and_return(0) }

    it 'if valid can be applied against a shopping cart to obtain a discount' do
      expect(cart).to receive(:discount=).with(5.0)
      voucher.apply_to(cart)
    end

    it 'if not valid, the discount is not applied' do
      expect(cart).not_to receive(:discount=)
      complex_voucher.apply_to(cart)
    end

  end

end