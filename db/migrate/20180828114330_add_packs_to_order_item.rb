class AddPacksToOrderItem < ActiveRecord::Migration[5.2]
  def change
  	add_reference :order_items, :pack, index: true
  end
end
