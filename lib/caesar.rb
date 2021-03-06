# frozen_string_literal: true

require 'date'
require 'allegedrc4'
require 'base64'
require 'verhoeff'
require 'qr_code'

class Caesar
  include QrGenerator

  def initialize
    @seed = nil
    @authorization_number = nil
    @invoice_number = nil
    @client_document = nil
    @transaction_date = nil
    @amount_total = nil
    @control_code = nil
    @owner_document = nil
    @amount_base = nil
    @amount_discount = 0
    @amount_rate = 0
    @amount_taxed = 0
    @amount_fiscal = 0
  end

  # @param [String] seed_str
  # @return [Caesar]
  def seed(seed_str)
    @seed = seed_str
    self
  end

  # @param [Integer] number
  # @return [Caesar]
  def authorization_number(number)
    @authorization_number = number
    self
  end

  # @param [Integer] number
  # @return [Caesar]
  def invoice_number(number)
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
  # Set the format of date Date.strptime("2007-07-02", "%Y-%m-%d")
  def transaction_date(date)
    day = Time.new(date.year, date.month, date.day).strftime('%d')
    month = Time.new(date.year, date.month, date.day).strftime('%m')
    @transaction_date = "#{date.year}#{month}#{day}"
    self
  end

  # @param [Float] amount
  # @return [Caesar]
  def amount_total(amount)
    raise ArgumentError 'Number cannot be 0 or less' if amount <= 0

    @amount_total = amount.round
    self
  end

  # @param [Float] amount
  # @return [Caesar]
  def amount_discount(amount)
    @amount_discount = amount
    self
  end

  # @param [Float] amount
  # @return [Caesar]
  def amount_fiscal(amount)
    @amount_fiscal = amount
    self
  end

  # @param [Float] amount
  # @return [Caesar]
  def amount_rate(amount)
    @amount_rate = amount
    self
  end

  # @param [Float] amount
  # @return [Caesar]
  def amount_taxed(amount)
    @amount_taxed = amount
    self
  end

  # @param [Float] number
  # @return [Caesar]
  def owner_document(number)
    @owner_document = number
    self
  end

  # @return [String]
  attr_reader :control_code

  # @return [Caesar]
  # This is the builder method for control code
  def build_control_code
    # Maybe can be a disaster, but this it the most legible way to do this.
    control_exception

    amount_total_vh, client_document_vh, invoice_number_vh, transaction_date_vh = calculate_verhoeff
    amount_variables = [
      invoice_number_vh.to_i,
      client_document_vh.to_i,
      transaction_date_vh.to_i,
      amount_total_vh.to_i
    ].sum { |obj| obj }

    amount_variables_vh_value = verhoeff(amount_variables, 5)
    verhoeff_array = Verhoeff.plus_one(amount_variables_vh_value)
    seed_array = split_seed(verhoeff_array)

    authorization_number_vh = "#{@authorization_number}#{seed_array[0]}"
    invoice_number_vh += seed_array[1]
    client_document_vh += seed_array[2]
    transaction_date_vh += seed_array[3]
    amount_total_vh += seed_array[4]

    message_str = authorization_number_vh + invoice_number_vh + client_document_vh + transaction_date_vh + amount_total_vh
    key_cipher = "#{@seed}#{amount_variables_vh_value}"
    message_alleged = AllegedRc4.to_alleged(message_str, key_cipher).delete('-')
    fifth_ascii_total, first_ascii_total, fourth_ascii_total, second_ascii_total, third_ascii_total = calculate_ascii_total(message_alleged, verhoeff_array)

    total_ascii_all = [first_ascii_total,
                       second_ascii_total,
                       third_ascii_total,
                       fourth_ascii_total,
                       fifth_ascii_total].sum { |obj| obj }
    total_msg = Base64.to_b64(total_ascii_all)
    @control_code = AllegedRc4.to_alleged(total_msg, key_cipher)
    self
  end

  def str_format
    "#{@owner_document}|#{@invoice_number}|#{@authorization_number}|#{@transaction_date}|#{@amount_total}|#{@amount_base}|#{@control_code}|#{@client_document}|#{@amount_rate}|#{@amount_taxed}|#{@amount_fiscal}|#{@amount_discount}"
  end

  private

  # @param [String] message_alleged
  # @param [String] verhoeff_array
  # @return [Array<Integer>]
  def calculate_ascii_total(message_alleged, verhoeff_array)
    total_ascii_sum = ascii_sum(message_alleged)
    first_ascii_total = (ascii_sum(message_alleged, 0, 5) * total_ascii_sum) / verhoeff_array[0]
    second_ascii_total = (ascii_sum(message_alleged, 1, 5) * total_ascii_sum) / verhoeff_array[1]
    third_ascii_total = (ascii_sum(message_alleged, 2, 5) * total_ascii_sum) / verhoeff_array[2]
    fourth_ascii_total = (ascii_sum(message_alleged, 3, 5) * total_ascii_sum) / verhoeff_array[3]
    fifth_ascii_total = (ascii_sum(message_alleged, 4, 5) * total_ascii_sum) / verhoeff_array[4]
    [fifth_ascii_total, first_ascii_total, fourth_ascii_total, second_ascii_total, third_ascii_total]
  end

  # @return [Array<String>]
  def calculate_verhoeff
    invoice_number_vh = "#{@invoice_number}#{verhoeff(@invoice_number, 2)}"
    client_document_vh = "#{@client_document}#{verhoeff(@client_document, 2)}"
    transaction_date_vh = "#{@transaction_date}#{verhoeff(@transaction_date, 2)}"
    amount_total_vh = "#{@amount_total}#{verhoeff(@amount_total, 2)}"
    [amount_total_vh, client_document_vh, invoice_number_vh, transaction_date_vh]
  end

  def control_exception
    control_exception_for(@seed)
    control_exception_for(@authorization_number)
    control_exception_for(@invoice_number)
    control_exception_for(@client_document)
    control_exception_for(@transaction_date)
    control_exception_for(@amount_total)
  end

  # @param [String] message
  # @param [Integer] initial_pos
  # @param [Integer] increment
  # @return [Integer]
  def ascii_sum(message, initial_pos = 0, increment = 1)
    sum = 0
    while initial_pos < message.length
      sum += message[initial_pos].ord
      initial_pos += increment
    end
    sum
  end

  # @param [Array] verhoeff_array
  # @return [Array]
  def split_seed(verhoeff_array)
    actual = 0
    seed_array = []
    verhoeff_array.length.times do |i|
      seed_array.push(@seed[actual, verhoeff_array[i]])
      actual += verhoeff_array[i]
    end
    seed_array
  end

  # @param [Integer] number
  # @param [Integer] loop
  def verhoeff(number, loop = 1)
    vh_number = ''
    loop.times do
      vh_number += Verhoeff.to_verhoeff(number.to_s + vh_number).to_s
    end
    vh_number
  end

  # @param [Object] value
  # @return [Exception]
  def control_exception_for(value)
    raise ArgumentError, "#{value.inspect} is Nil" if value.nil?
  end
end