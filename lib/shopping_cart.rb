require_relative 'formatter'

class ShoppingCart

  include Formatter

  attr_reader   :products
  attr_accessor :discount

  def initialize
    @products = []
    @discount = 0
  end

  def clear_discounts
    @discount = 0
    self
  end

  def add(product)
    contains?(product) ? add_to_stock(product) : add_new(product)
  end

  def remove(product)
    missing_product_error unless contains?(product)
    remove_from_stock(product)
  end

  def has_footwear_item?
    products.map(&:category).any?{ |cat| cat.downcase =~ /footwear/}
  end

  def total
    raw_total - discount
  end 

  def formatted_total
    format_ccy(total)
  end

  def formatted_discount
    format_ccy(discount)
  end

  private

  def product_by(id)
    products.select{ |product| product.id == id }.first
  end
  
  def add_to_stock(product)
    product_by(product.id).stock += product.stock
  end

  def add_new(product)
    @products << product
  end

  def remove_from_stock(product)
    product_by(product.id).stock -= product.stock
    delete(product) if all_removed?(product)
  end

  def all_removed?(product)
    product_by(product.id).stock <= 0
  end

  def delete(product)
    @products.delete(product_by(product.id))
  end

  def missing_product_error
    raise 'Error:product is not in the cart'
  end

  def raw_total
    products.map(&:stock_value).inject(0, :+)
  end

  def product_ids
    products.map(&:id)
  end

  def contains?(product)
    product_ids.include?(product.id)
  end

end