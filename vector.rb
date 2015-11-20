#! /usr/bin/env ruby

class Vector
	attr_reader :values
	def initialize values
		@values = values
	end

	def +(vector)
		new_values = values.each_with_index.map { |value, idx| value + vector.values[idx] }
		Vector.new new_values
	end

	def *(scalar)
		new_values = @values.map {|value| scalar * value}
		Vector.new new_values
	end
end

class ComplexNumber
	attr_reader :real, :imaginary

	def initialize real = 0, imaginary = 0
		@real = real
		@imaginary = imaginary
	end

	def conjugate
		ComplexNumber.new(@real, - @imaginary)
	end

	def to_s
		operator = if imaginary >= 0
					   '+'
				   else
					   '-'
				   end

		"(#{@real}#{operator}#{@imaginary.abs}i)"
	end
end

c = ComplexNumber.new(3, 4)
print c.to_s
