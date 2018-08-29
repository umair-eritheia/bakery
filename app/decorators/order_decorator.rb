class OrderDecorator < Draper::Decorator
  delegate_all

	
	def product_total(product)
		order.order_items.select{|c| c.product.code == product}.sum(&:item_total)
	end

	def order_item_codes
		order.order_items.group_by{|c| c.product.code}.keys
	end

	def product_quantities(product)
		quantity = 0
		order.order_items.select{|c| c.product.code == product}.each do |item|
			quantity+=(item.pack.pack_quantity * item.quantity)
		end
		"#{quantity}" " #{product}"
	end
end
