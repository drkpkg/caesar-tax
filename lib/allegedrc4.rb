module AllegedRc4
  # @param [String] message, key
  # @param [String] key
  # @return [String]
  def self.to_alleged(message, key)
    index1 = 0
    index2 = 0

    result = ''
    state = []
    (0..255).each { |i|
      state.push i
    }

    (0..255).each { |i|
      index2 = (key[index1].ord + state[i] + index2) % 256
      state[i], state[index2] = swap_val(state[i], state[index2])
      index1 = (index1 + 1) % key.length
    }

    x = 0
    y = 0
    (0..message.length-1).each { |i|
      x = (x + 1) % 256
      y = (state[x] + y) % 256
      state[x], state[y] = swap_val(state[x], state[y])
      message_str = message[i].ord ^ state[(state[x] + state[y]) % 256]
      result += '-' + fill_zero(message_str.to_s(16))
    }
    result[1, result.length-1].upcase
  end

  private

  # @param [String] val
  # @return [String]
  def self.fill_zero(val)
    return "0#{val}" if val.length == 1
    val
  end

  def self.swap_val(value_for, value_to)
    return value_to, value_for
  end
end