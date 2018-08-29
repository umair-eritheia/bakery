module OrdersHelper

	def show_order_item(order_item, product)
		if order_item.product.code == product.split(" ").last
			raw("<div>#{order_item.quantity}" + " x " + "#{order_item.pack.pack_quantity}" + " $" + "#{order_item.item_total}</div>") 

		end
	end
end
