
class Caesar
  def initialize
    @seed = nil
    @authorization_number = nil
    @invoice_number = nil
    @client_document = nil
    @transaction_date = nil
    @amount_total = nil
    @control_code = nil
  end

  # @param [String] seed_str
  # @return [Caesar]
  def seed=(seed_str)
    @seed = seed_str
    self
  end

  # @param [Integer] number
  # @return [Caesar]
  def authorization_number=(number)
    @authorization_number = number
    self
  end

  # @param [Integer] number
  # @return [Caesar]
  def invoice_number=(number)
    @invoice_number = number
    self
  end

  # @param [Integer] number
  # @return [Caesar]
  def client_document(number)
    @client_document = number
    self
  end

  # @param [DateTime]
  # @return [Caesar]
  def transaction_date=(date)
    @transaction_date = "#{date.year}#{date.month}#{date.day}"
    self
  end

  # @param [Float] amount
  # @return [Caesar]
  def amount_total=(amount)
    raise ArgumentError "Number cannot be 0 or less" if amount<=0
    @amount_total = amount.round
    self
  end

  # @return [String]
  def control_code
    @control_code
  end

  def build_control_code
    control_exception_for(@seed)
    control_exception_for(@authorization_number)
    control_exception_for(@invoice_number)
    control_exception_for(@client_document)
    control_exception_for(@transaction_date)
    control_exception_for(@amount_total)

  end

  private

  def control_exception_for(value)
    raise ArgumentError "#{value.inspect} is Nil"
  end
end