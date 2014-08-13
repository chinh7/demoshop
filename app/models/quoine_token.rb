class QuoineToken < ActiveRecord::Base

  def to_auth
    {
      user_id: quoine_user_id,
      token: value
    }
  end
end
