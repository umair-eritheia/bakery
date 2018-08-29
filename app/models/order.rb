class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy

  accepts_nested_attributes_for :order_items

  def self.make_order(products, product_params)
  	@order = self.new(customer_id: Customer.first.id)
  	products.each do |product|
	  	product_values = product.values.flatten.first
	  	quantity_products = product_values.keys.select{|c| !c.include?("price") }
	  	@product = Product.with_packs.find_by_code(product.keys.first)
	  	@product.packs.where('pack_quantity IN (?)', quantity_products.map(&:to_i)).each do |pack|
	  		@order.order_items.build(product_id: @product.id, pack_id: pack.id, quantity: product_values[pack.pack_quantity.to_s], item_total: product_values[pack.pack_quantity.to_s] * pack.price)
	  	end
  	end
  	@order.total = @order.order_items.sum(&:item_total).to_f
  	@order
  end
end
