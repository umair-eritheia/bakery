class Pack < ApplicationRecord
  belongs_to :product
	has_many :order_items, dependent: :destroy
  	VS5_PACK_QUANTITIES = [{"small" => 3, "price" => 6.99}, {"large" => 5, "price" => 8.99}]
	MB11_PACK_QUANTITIES = [{"small" => 2, "price" => 9.95}, {"medium" => 5, "price" => 16.95}, {"large" => 8, "price" => 24.95}]
	CF_PACK_QUANTITIES = [{"small" => 3, "price" => 5.95}, {"medium" => 5, "price" => 9.95}, {"large" => 9, "price" => 16.99}]
end
