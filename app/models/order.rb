class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  serialize :invoice, Hash

  def make_wallet_payment_request(email)
    data = {
      auth: QuoineToken.first_or_create.to_auth,
      email: email,
      request: {
        title: "Order #{id}",
        data: "Total price: $#{price}",
        to_address: invoice["bitcoin_address"],
        sat_amount: invoice["sat_price"]
      }
    }.to_json
    result = HTTPClient.new.post("#{ENV['QWALLET_URL']}/api/out_requests",
                                 data, {'Content-Type' => 'application/json'})
    result.code == 200
  end
end
