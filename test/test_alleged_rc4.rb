require 'minitest/autorun'
require 'allegedrc4'

class AllegedRc4Test < Minitest::Test
  def test_assert_alleged_rc4
    assert_equal AllegedRc4.to_alleged("d3Ir6", "sesamo"), "EB-06-AE-F8-92"
  end
end