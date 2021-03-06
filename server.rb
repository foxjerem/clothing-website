require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/config_file'
require 'rack-flash'

Dir[File.join(__dir__, 'lib', '*.rb')].each {|file| require file }

class ClothingEStore < Sinatra::Base

  configure do
    enable :sessions
    use Rack::Flash

    product_file  = 'data_files/products.txt'
    voucher_file  = 'data_files/vouchers.txt'

    product_array = ObjectLoader.products_from(product_file)
    voucher_array = ObjectLoader.vouchers_from(voucher_file)

    CART          = ShoppingCart.new
    PRODUCTS      = DatabaseTable.new(product_array)
    VOUCHERS      = DatabaseTable.new(voucher_array)
  end

  get '/' do
    @products = PRODUCTS.all
    @cart     = CART.clear_discounts
    @vouchers = VOUCHERS.all
    
    erb :index
  end

  get '/cart/update/:id' do
    product = PRODUCTS.find(params[:id])

    if product.in_stock?
      CART.add(product.pop_single)
    else
      out_of_stock_error
    end

    redirect '/'
  end

  get '/cart/remove/:id' do
    product = PRODUCTS.find(params[:id])

    CART.remove(product.push_single)
    
    redirect '/'
  end

  get '/voucher/redeem/:id' do
    voucher = VOUCHERS.find(params[:id])
    
    status = voucher.apply_to(CART)

    if status == :fail
      fail_response
    else
      voucher_response
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0

  private

  def out_of_stock_error
    flash[:error] = 'The selected product is out of stock'
  end

  def fail_response
    json({ status: 'fail' })
  end

  def voucher_response
    json({ status: 'ok', discount: CART.discount, total: CART.total })
  end

end
