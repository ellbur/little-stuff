require 'test/unit'

class A_joe_when_reset < Test::Unit::TestCase
  def setup
    DUT.reset!
  end

  def test_c
    # assert DUT.c ..., "c should ..."
  end

  def test_a
    # assert DUT.a ..., "a should ..."
  end

  def test_b
    # assert DUT.b ..., "b should ..."
  end
end
