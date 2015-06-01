class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  serialize :invoice, Hash

  def make_wallet_payment_request(email)
    # TODO
    raise "Unimplemented"

    data = {
      email: email,
      request: {
        title: "Order #{id}",
        data: "Total price: $#{price}",
        to_address: invoice["bitcoin_address"],
        amount: invoice["bitcoin_amount"]
      }
    }
    req = RestClient::Request.new(
      url: "#{ENV['QPAY_URL']}/api/v1/out_requests",
      payload: data,
      method: :post
    )

    req.execute do |res, req, result|
      result.code == '200'
    end
  end
end
