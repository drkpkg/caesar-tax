module Base64
  @dict = %w(0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z + /)

  # @param [Integer]
  # @return [String]
  def self.to_b64(number)
    word = ''
    while number > 0
      number_part = number.to_i / 64
      number_res = number % 64
      word = @dict[number_res] + word
      number = number_part
    end
    word
  end
end