def fib(n, n1 = 1, n2 = 1)
	return n2 if n == 0
	return fib(n - 1, n1 + n2, n1)
end
