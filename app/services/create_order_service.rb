class CreateOrderService

  def self.is_product_available(product_param)
    product = Product.with_packs.find_by_code(product_param[1])
    product.present? && product.packs.sum(&:available_quantity) > product_param[0].to_i ? product : nil 
  end

  def self.findCombinationsUtil(arr, index, num, reducedNum)
  
    # Base condition
    if reducedNum < 0
      return
    end

    # If combination is found, print it
    if reducedNum == 0    
      i = 0
      new_str = ""
      
      while(i < index)
        new_str = [new_str, arr[i]].join(',')
        i+=1
      end    
      @combinations << new_str
      return new_str
    end
    # Find the previous number stored in arr[]
    # It helps in maintaining increasing order
    
    prev = index == 0 ? 1 : arr[index-1];

    # note loop starts from previous number
    # i.e. at array location index - 1
    k = prev
    while k<=num
      arr[index] = k
      findCombinationsUtil(arr, index + 1, num, reducedNum - k)
      k+=1
    end

  end 

  # Function to find out all combinations of positive numbers that add upto given number. 
  # It uses findCombinationsUtil()
  def self.findCombinations(n)
    # array to store the combinations
    # It can contain max n elements
    
    arr = Array.new(n)

    # find all combinations
    findCombinationsUtil(arr, 0, n, n)
  end

  def self.make_distribution(product, packs_needed)
    packs = product.packs.pluck('pack_quantity', 'available_quantity').to_h
    @combinations = []
    # finding combinations of number
    findCombinations(packs_needed.to_i)

    denominations = packs.keys    
    # filtering combinations on the basis of denominations
    filtered_combinations = []
    # filtering combinations having available denominations
    filtered_combinations = denominations.map { |deno| @combinations.select{|c| c.include?(deno.to_s)} }.try(:flatten).try(:uniq)
    most_filtered = []
    # filtering combinations tp contain only available denominations
    filtered_combinations.map {|combination| most_filtered << combination if (combination.split(",").reject{|c| c == ""}.map(&:to_i) - denominations.map(&:to_i)).blank? }.flatten.compact

    finalized_denos = []
    # cleaning suitable denominations and calculating the required amount of each denomination 
    if most_filtered.blank?
      denos = []
      filtered_combinations.map {|combination| denominations.map{|deno| denos << deno if combination.include?(deno.to_s)}}
      if denos.present?
        smaller_or_equal_denos = denos.uniq.select{|c| c <= n }
        if smaller_or_equal_denos.present? 
          deno_hash = []
          smaller_or_equal_denos.each_with_index do |deno, index|
            total = 0
            inc = 2
            loop do 
              total = deno * inc
              break if total >= n 
              inc+=1
            end
            deno_hash << {"#{deno}" => "#{inc}"}
          end
          finalized_denos << deno_hash 
        end
      end
    else
      most_filtered.each do |combination|
        refined_combination = combination.chars.reject!{|c| c == ","}
        @hsh_combination = {}
        refined_combination.uniq.each do |uniqee|
          @hsh_combination.merge!("#{uniqee}" => refined_combination.count(uniqee))
        end
        finalized_denos << @hsh_combination
      end
    end
    finalized_denos  
  end

  def self.select_denomination(denominations)
    denominations.select{|c| c.keys.include?(denominations.map(&:keys).flatten.max)}
  end

  def self.configure_order(products_param)
    final_denomination = []
    products_param.each do |product_param|
      product = is_product_available(product_param.split(" "))
      if product.present?
        denomination_sets = make_distribution(product, product_param.split(" ")[0])
        final_denomination << {product.code => denomination_sets.count == 1 ? denomination_sets : select_denomination(denomination_sets)}
      end  
    end
    final_denomination
  end
end