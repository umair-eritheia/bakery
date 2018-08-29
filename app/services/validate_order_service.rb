class ValidateOrderService
	def self.validate_params(products)
    arr = []
    pattern = Regexp.new("^[0-9]+ [a-zA-Z0-9]+").freeze
    products.map{ |product| arr << pattern.match?(product) }
    arr.flatten.include?(false)
  end
end