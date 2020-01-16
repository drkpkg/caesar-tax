require 'minitest/autorun'
require 'base64'

class Base64Test < Minitest::Test
  def test_assert_number
    assert_equal Base64.to_b64(934598591), 'tjDU/'
  end
end