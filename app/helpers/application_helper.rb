module ApplicationHelper
  def current_cart
    @current_cart ||= Cart.from_json(session['current_cart'])
  end

  def save_current_cart
    session['current_cart'] = current_cart.as_json
  end
end
