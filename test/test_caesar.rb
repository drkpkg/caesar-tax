# frozen_string_literal: true

require 'minitest/autorun'
require 'data/cases'
require 'caesar'

class CaesarTest < Minitest::Test
  def setup
    @data = Cases.data
  end

  def test_cases
    @data.each do |actual_case|
      result = Caesar.new
                     .authorization_number(actual_case[0].to_i)
                     .invoice_number(actual_case[1].to_i)
                     .client_document(actual_case[2].to_i)
                     .transaction_date(Date.strptime(actual_case[3], '%Y/%m/%d'))
                     .amount_total(actual_case[4].to_f)
                     .seed(actual_case[5])
                     .build_control_code
      assert_equal result.control_code, actual_case[10]
    end
  end
end
