class CallbacksController < ApplicationController
  LOG_ROTATE_SIZE = 1.megabytes # bytes

  SECRET_KEY = 'DO_NOT_TELL_ANYONE'

  skip_before_filter :verify_authenticity_token
  before_action :authenticate_callback
  before_action :log_callback

  def quoine_payments
    if params[:invoice]
      order = Order.find(params[:invoice][:data])
      order.update(invoice_id: params[:invoice][:id], invoice: params[:invoice])
    end
    render json: {
      status: :success
    }
  end

  def log_callback
    logger = Logger.new(Rails.root.join('log', 'callback.log'), 2, LOG_ROTATE_SIZE)
    logger.debug("\n#{Time.current}:")
    logger.debug(params)
  end


  private
  def authenticate_callback
    quoine_token = QuoineToken.first_or_create
    user_id = ApiAuth.access_id(request)
    if quoine_token.quoine_user_id != user_id.to_i ||
      !ApiAuth.authentic?(request, quoine_token.value)
      render status: :unauthorized, json: {
        status: 'fail'
      }
    end
  end
end
