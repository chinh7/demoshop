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

  def create_order(user_id)
    quoine_token = QuoineToken.first
    raise "Quoine Token not found" unless quoine_token

    order = Order.create(user_id: user_id, price: self.total_price)
    items.each do |item_id|
      order.order_items.create(item_id: item_id)
    end

    data = {
      price: order.price,
      data: {
        order_id: order.id,
        items: Item.select(:id, :name, :price).where(id: self.items)
      }.to_json,
      name: "Invoice for order #{order.id}"
    }.to_json

    req = RestClient::Request.new(
      url: "#{ENV['QPAY_URL']}/api/v1/invoices",
      payload: data,
      method: :post
    )
    quoine_token.sign!(req)
    req.execute do |res, req, result|
      if result.code == '200'
        invoice = JSON.parse(res)
        order.update(invoice_id: invoice['id'], invoice: invoice)
      else
        order.destroy
      end
      order
    end
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
