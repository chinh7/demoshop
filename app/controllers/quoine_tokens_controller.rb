class QuoineTokensController < ApplicationController
  def new
    @quoine_token = QuoineToken.first_or_create
  end

  def create
    data = {
      email: params[:email],
      password: params[:password]
    }
    req = RestClient::Request.new(
      url: "#{ENV['QPAY_URL']}/api/v1/api_secret_key",
      payload: data,
      method: :post
    )
    req.execute do |res, req, result|
      @quoine_token = QuoineToken.first_or_create
      if result.code == '200'
        token = JSON.parse(res)
        @quoine_token.update(
          quoine_user_id: token['user_id'],
          value: token['api_secret_key'],
          callback: token['user']['payments_callback']
        )
      elsif result.code == '401'
        flash.alert = "Invalid email or password"
      else
        flash.alert = "Something went wrong"
      end
      redirect_to action: :new
    end

  end

  def set_callback
    @quoine_token = QuoineToken.first_or_create
    data = {
      callback: params[:callback]
    }.to_json
    req = RestClient::Request.new(
      url: "#{ENV['QPAY_URL']}/api/v1/payments_callback_url",
      payload: data,
      method: :post,
    )
    @quoine_token.sign!(req)

    req.execute do |res, req, result|
      if result.code == '200'
        @quoine_token.update(callback: params[:callback])
      else
        flash.alert = 'Can not set callback'
      end
      redirect_to action: :new
    end
  end
end
