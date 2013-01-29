def make_change(amount, coins = [25, 10, 5, 1])
	results = Array.[]
	results[0] = Array.[]

	for i in 1..amount
  		results[i] = 
  			coins.
  			map { |coin| 
  				Array.new(results[i - coin]).push(coin) if coin <= i }.
  			select { |list|  
  				list.is_a? Array }.
  			min { |a, b| 
  				a.length <=> b.length }
  	end

  	return results[amount]
end