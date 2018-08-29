# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product::PRODUCTCODES.each do |product_code|
	product = Product.find_or_create_by!(name: Product.product_name(product_code), code: product_code)
	packs = eval("Pack::#{product_code}_PACK_QUANTITIES")
	packs.each do |pack|
		product.packs.find_or_create_by!(name: pack.keys.first, price: pack["price"], pack_quantity: pack["#{pack.keys.first}"], available_quantity: 100)
	end
end

Customer.find_or_create_by!(name: "Alex", email: 'alex@gmail.com')