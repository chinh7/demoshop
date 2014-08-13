class QuoineTokensController < ApplicationController
  def new
    @quoine_token = QuoineToken.first_or_create
  end

  def create
    data = {
      user: {
        email: params[:email],
        password: params[:password]
      }
    }.to_json
    result = HTTPClient.new.post("#{ENV['QWALLET_URL']}/api/payments_token",
                                 data, {'Content-Type' => 'application/json'})
    @quoine_token = QuoineToken.first_or_create
    if result.code == 200
      token = JSON.parse(result.content)
      @quoine_token.update(quoine_user_id: token['user_id'], value: token['token'])
    else
      flash.alert = "Invalid email or password"
    end
    redirect_to action: :new
  end

  def set_callback
    @quoine_token = QuoineToken.first_or_create
    data = {
      auth: @quoine_token.to_auth,
      callback: params[:callback]
    }.to_json
    result = HTTPClient.new.post("#{ENV['QWALLET_URL']}/api/set_payments_callback",
                                 data, {'Content-Type' => 'application/json'})
    if result.code == 200
      @quoine_token.update(callback: params[:callback])
    else
      flash.alert = 'Can not set callback'
    end
    redirect_to action: :new
  end
end
