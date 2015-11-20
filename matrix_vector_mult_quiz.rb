require 'byebug'
# Question: illegal, matrix vector, vector matrix
MAX_NUMBER_ILLEGAL = 5
MAX_NUMBER_MV = 5
MAX_NUMBER_VM = 5

MAX_MATRIX_HEIGHT = 3
MAX_MATRIX_WIDTH = 3
MAX_VECTOR_WIDTH = 3

MAX_SCALAR_VALUE = 3


def randomized_number max
	rand(max) + 1
end

def random_true_or_false
	randomized_number(2) % 2 == 0
end

def generate_vector_width
	randomized_number(MAX_VECTOR_WIDTH)
end

def generate_matrix_height
	randomized_number(MAX_MATRIX_HEIGHT)
end

def generate_matrix_width
	randomized_number(MAX_MATRIX_WIDTH)
end

def generate_vector width
	vector = Array.new(width)
	vector.map {|n| randomized_number(MAX_SCALAR_VALUE)}
end

def generate_matrix height, width
	rows = Array.new(height)
	rows.map { generate_vector(width) }
end

def generate_legal_question(is_vm:)
	vector_width = generate_vector_width
	matrix_height = generate_matrix_height
	matrix_width = generate_matrix_width

	matrix_height = generate_matrix_height while matrix_height == 1
	matrix_width = generate_matrix_width while matrix_height == matrix_width || matrix_width == 1

	if is_vm
		vector_width = matrix_height
	else
		vector_width = matrix_width
	end

	vector = generate_vector(vector_width)
	matrix = generate_matrix(matrix_height, matrix_width)

	return is_vm ? {left: vector, right: matrix} : {left: matrix, right: vector}
end

def generate_illegal_question
	is_vm = random_true_or_false

	vector_width = generate_vector_width
	matrix_height = generate_matrix_height
	matrix_width = generate_matrix_width

	compare_to = is_vm ? matrix_height : matrix_width

	matrix_height = generate_matrix_height while matrix_height == 1
	matrix_width = generate_matrix_width while matrix_height == matrix_width || matrix_width == 1
	vector_width = generate_vector_width while vector_width == compare_to || vector_width == 1

	if is_vm
		vector_width = matrix_width
	else
		vector_width = matrix_height
	end

	vector = generate_vector(vector_width)
	matrix = generate_matrix(matrix_height, matrix_width)

	return is_vm ? {left: vector, right: matrix} : {left: matrix, right: vector}
end

def matrix? m
	m.first.is_a?(Array)
end

def matrix_side question
	matrix?(question[ :left ]) ? :left : :right
end

def print_vector v
	print v
end

def determine_indent(vector)
	vector.length + 5 + 2 * (vector.length - 1)
end

def print_indent indent
	print ' ' * (indent)
end

def last_row? m, index
	index == m.length - 1
end

def print_matrix(matrix:, indent: 0, include_last: true)
	indent += 3 unless indent == 0

	matrix.each_with_index do |row, index|
		print_indent(indent)
		print '[' if index == 0
		print_vector(row) if !last_row?(matrix, index) || include_last
		puts unless last_row?(matrix, index)
	end

	print ']' if include_last
end

def print_question question
	if matrix_side(question) == :left
		print_matrix matrix: question[:left], indent: 0
		print ' * '
		print_vector question[:right]
	else
		print_matrix matrix: question[:right], indent: determine_indent(question[:left])
		puts
		print_vector question[:left]
		print ' * '
	end

	puts
end

def generate_illegal_questions count
	(1..count).map do
		generate_illegal_question
	end
end

def generate_legal_questions(vm: true, count:)
	(1..count).map do
		generate_legal_question is_vm: vm
	end
end

def legal? question
	side = matrix_side(question)

	if side == :left
		return question[:left].first.length == question[:right].length
	end

	return question[:left].length == question[:right].length
end

question_count = {
	illegal: randomized_number(MAX_NUMBER_ILLEGAL),
	mv: randomized_number(MAX_NUMBER_MV),
	vm: randomized_number(MAX_NUMBER_VM)
}

questions = []

questions += generate_illegal_questions(question_count[:illegal])
questions += generate_legal_questions(vm: false, count: question_count[:mv])
questions += generate_legal_questions(vm: true, count: question_count[:vm])

questions.shuffle.each do |question|
	print_question(question)
	puts
	print 'Is this question legal or illegal: '
	response = gets.chomp

	if ('legal' == response) == legal?(question)
		puts "That's right!"
	else
		puts "Nope - wrong!"
	end

	puts
end
