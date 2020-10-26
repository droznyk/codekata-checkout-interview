require "minitest/autorun"
require_relative "../lib/checkout"


class TestPrice < Minitest::Test

  # TODO: RULES go here, you decide which data structure is the best
  RULES = {
    "A" => {
      regular_price: 50,
      discount_items_count: 3,
      discount_price: 130
    },
    "B" => {
      regular_price: 30,
      discount_items_count: 2,
      discount_price: 45
    },
    "C" => {
      regular_price: 20
    },
    "D" => {
      regular_price: 15
    }
  }

  def price(goods)
    co = ::Checkout.new(RULES)
    goods.split(//).each { |item| co.scan(item) }
    co.total
  end

  def test_totals
    assert_equal(  0, price(""))
    assert_equal( 50, price("A"))
    assert_equal( 80, price("AB"))
    assert_equal(115, price("CDBA"))

    assert_equal(100, price("AA"))
    assert_equal(130, price("AAA"))
    assert_equal(180, price("AAAA"))
    assert_equal(230, price("AAAAA"))
    assert_equal(260, price("AAAAAA"))

    assert_equal(160, price("AAAB"))
    assert_equal(175, price("AAABB"))
    assert_equal(190, price("AAABBD"))
    assert_equal(190, price("DABABA"))
  end

  def test_incremental
    co = ::Checkout.new(RULES)
    assert_equal(0, co.total)
    co.scan("A");  assert_equal( 50, co.total)
    co.scan("B");  assert_equal( 80, co.total)
    co.scan("A");  assert_equal(130, co.total)
    co.scan("A");  assert_equal(160, co.total)
    co.scan("B");  assert_equal(175, co.total)
  end
end
