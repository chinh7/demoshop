class CallbacksController < ApplicationController
  SECRET_KEY = 'DO_NOT_TELL_ANYONE'

  skip_before_filter :verify_authenticity_token
  before_action :check_secret_key
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
    FileUtils::mkdir_p Rails.root.join('log')
    File.open(Rails.root.join('log/callback.log'), 'a') do |f|
      f.puts "\n#{Time.current}:"
      f.puts params
    end
  end

  private
  def check_secret_key
    if params[:secret_key] != SECRET_KEY
      render status: :unauthorized, json: {
        status: 'fail'
      }
    end
  end
end
