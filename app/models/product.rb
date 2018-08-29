class Product < ActiveRecord::Base

	has_many :packs, dependent: :destroy
	has_many :order_items, dependent: :destroy
	
	[:name, :code].each do |column|
		validates column, presence: true
		validates column, uniqueness: true
	end
  
  scope :with_packs, -> { includes(:packs) }
	
  PRODUCTCODES = ['VS5', 'MB11', 'CF']
	PRODUCTS = {'VS5' => 'Croissant', 'MB11' => 'Vegemite Scroll', 'CF' => 'Blueberry Muffin'}
	

  def self.product_name(code)
  	Product::PRODUCTS["#{code}"]
  end
  
  # make products from selected denominations and products table
  def self.make_products(denominations)
  	@products = Product.with_packs.where(code: denominations.map(&:keys).flatten)
  	array_of_denos = {}
  	denominations.present? && denominations.each do |denomination|
  		denos = denomination.keys.first
  		product_packs = @products.find_by_code(denos).packs
  		array_of_prices = {}
  		denomination[denos].present? && denomination[denos].first.each do |deno|
				selected_packs = product_packs.where('pack_quantity = ?', deno.first.to_i)
				array_of_prices.merge!("#{deno[0]}_price" => selected_packs.find_by_pack_quantity(deno[0].to_i).price)
  		end
  		array_of_denos.merge!(denos => array_of_prices)
  	end
  	denominations.map{|c| c.values.first.first.merge!(array_of_denos[c.keys.first])}
  	denominations
  end
end