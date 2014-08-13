json.array!(@orders) do |order|
  json.extract! order, :id, :user_id, :price, :invoice_id
  json.url order_url(order, format: :json)
end
