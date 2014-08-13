class Cart
  attr_accessor :items

  def initialize(items=[])
    self.items = items
  end

  def add_item(item_id)
    self.items << item_id
  end

  def remove_item(item_id)
    self.items.delete_at(self.items.index(item_id))
  end

  def total_price
    self.items.map do |item_id|
      item = Item.find(item_id)
      item.price
    end.sum
  end

  def as_json
    {
      items: items
    }.to_json
  end

  def self.from_json(cart_json)
    if cart_json
      cart = JSON.parse(cart_json)
      self.new(cart['items'])
    else
      self.new()
    end
  end
end
