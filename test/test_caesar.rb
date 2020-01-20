# frozen_string_literal: true

require 'minitest/autorun'
require 'quirc'
require 'chunky_png'
require 'data/cases'
require 'caesar'

class CaesarTest < Minitest::Test
  def setup
    @data = Cases.data
    @qr_path = '/tmp/test_qr.png'
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

  def test_data_qr
    result = Caesar.new
                   .authorization_number('123456'.to_i)
                   .invoice_number('1'.to_i)
                   .client_document('1213432'.to_i)
                   .owner_document('76534321'.to_i)
                   .transaction_date(Date.strptime('2020/04/05', '%Y/%m/%d'))
                   .amount_total('40.40'.to_f)
                   .seed('#Vti+GE\sdnsdHf4JjKtC*ImSWzyIsct[yqQUGVmb)AEV]rxC$Cua@#F*bR4-rti')
                   .build_control_code
    result.save(@qr_path)
    img = ChunkyPNG::Image.from_file(@qr_path)
    res = Quirc.decode(img).first
    assert_equal result.str_format, res.payload
  end
end
