class QuoineTokensController < ApplicationController
  def new
    @quoine_token = QuoineToken.first_or_create
  end

  def create
    @quoine_token = QuoineToken.first_or_create
    @quoine_token.quoine_user_id = params[:quoine_user_id]
    @quoine_token.value = params[:api_secret_key]

    curl = Curl::Easy.new("#{ENV['QPAY_URL']}/api/v1/profile")
    @quoine_token.sign!(curl)

    curl.get

    if curl.response_code == 200
      @quoine_token.callback = JSON.parse(curl.body_str)["settings"]["payments_callback"]
      @quoine_token.save
      flash.notice = 'Api secret key updated'
    else
      flash.alert = 'Invalid API secret key or user id'
    end
    redirect_to action: :new
  end

  def set_callback
    @quoine_token = QuoineToken.first_or_create
    curl = Curl::Easy.new("#{ENV['QPAY_URL']}/api/v1/payments_callback_url")
    curl.post_body = {
      callback: params[:callback]
    }.to_json

    @quoine_token.sign!(curl)

    curl.post

    if curl.response_code == 200
      @quoine_token.update(callback: params[:callback])
    else
      flash.alert = 'Can not set callback'
    end
    redirect_to action: :new
  end
end
