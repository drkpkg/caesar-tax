module Verhoeff
  @mult_matrix = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                 [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
                 [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
                 [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
                 [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
                 [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
                 [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
                 [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
                 [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
                 [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]]
  @permutations_matrix = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                          [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
                          [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
                          [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
                          [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
                          [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
                          [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
                          [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]]
  @numbers = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9]

  # @param [String] word
  # @return [Integer]
  def self.to_verhoeff(word)
    check = 0
    reverse_number = word.reverse
    i = 0
    while i <= (reverse_number.length - 1) do
      check = @mult_matrix[check][@permutations_matrix[((i + 1) % 8)][reverse_number[i].to_i]]
      i += 1
    end
    @numbers[check]
  end

  # @param [String] message
  # @return [Array]
  def self.plus_one(message)
    msg_array = message.split('')
    msg_result = []
    msg_array.each do |actual_msg|
      msg_result.push(actual_msg.to_i + 1)
    end
    msg_result
  end
end