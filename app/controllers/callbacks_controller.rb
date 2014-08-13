class CallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token
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
end
