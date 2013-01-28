def sort(arr)
	return arr if arr.length <= 1
	pivotIndex = rand(arr.length)
	left, middle, right = split(pivotIndex, arr)
	return sort(left) + middle + sort(right)
end

def split(index, arr)
	pivot = arr[index]
	left = Array.[]
	right = Array.[]
	middle = Array.[]
	arr.each { |x|
		case pivot <=> x
			when 0
				middle.push x
			when 1
				left.push x
			else
				right.push x
			end
	}
	return left, middle, right
end