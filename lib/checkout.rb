class Rule
  attr_reader :item_name, :regular_price, :discount_items_count, :discount_price

  def initialize(item_name, rules)
    @item_name = item_name
    @regular_price = rules[:regular_price]
    @discount_items_count = rules[:discount_items_count]
    @discount_price = rules[:discount_price]
  end
end

class Total
  attr_reader :items_count, :rule, :total

  def initialize(items_count, rule)
    @items_count = items_count
    @rule = rule
    @total = 0
  end

  def result
    return total if @items_count == 0

    calculate_total
  end

  private

  def calculate_total
    if rule.discount_items_count && items_count >= rule.discount_items_count.to_i
      @total += (items_count / rule.discount_items_count) * rule.discount_price
      @total += (items_count % rule.discount_items_count) * rule.regular_price
    else
      @total += items_count * rule.regular_price
    end

    total
  end
end

class Checkout
  def initialize(rules)
    @rules = rules.map { |rule| Rule.new(*rule) }
    @items = []
  end

  def scan(item)
    @items << item
  end

  def total
    calculate_total
  end

  private

  def calculate_total
    totals_array = @rules.map { |rule| Total.new(count_items_by_name(rule.item_name), rule) }
    totals_array.map(&:result).inject(:+)
  end

  def count_items_by_name(item_name)
    @items.count(item_name)
  end
end
