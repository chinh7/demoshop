class QuoineTokensController < ApplicationController
  def new
    @quoine_token = QuoineToken.first_or_create
  end

  def create
    @quoine_token = QuoineToken.first_or_create
    @quoine_token.quoine_user_id = params[:quoine_user_id]
    @quoine_token.value = params[:api_secret_key]
    req = RestClient::Request.new(
      url: "#{ENV['QPAY_URL']}/api/v1/profile",
      method: :get
    )
    @quoine_token.sign!(req)

    req.execute do |res, req, result|
      if result.code == '200'
        @quoine_token.callback = JSON.parse(result.body)["settings"]["payments_callback"]
        @quoine_token.save
        flash.notice = 'Api secret key updated'
      else
        flash.alert = 'Invalid API secret key or user id'
      end
    end
    redirect_to action: :new
  end

  def set_callback
    @quoine_token = QuoineToken.first_or_create
    data = {
      callback: params[:callback]
    }.to_json
    req = RestClient::Request.new(
      url: "#{ENV['QPAY_URL']}/api/v1/payments_callback_url",
      payload: data,
      method: :post
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
