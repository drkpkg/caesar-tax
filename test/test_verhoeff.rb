require 'minitest/autorun'
require 'verhoeff'

class VerhoeffTest < Minitest::Test
  def test_assert_verhoeff
    assert_equal Verhoeff.to_verhoeff("12083"), 7
  end
end