class QuoineToken < ActiveRecord::Base

  def sign!(req)
    req.headers['Content-Type'] = 'application/json'
    ApiAuth.sign!(req, quoine_user_id, value)
  end
end
