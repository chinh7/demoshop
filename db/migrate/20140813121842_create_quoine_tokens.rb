class CreateQuoineTokens < ActiveRecord::Migration
  def change
    create_table :quoine_tokens do |t|
      t.integer :quoine_user_id
      t.string :value
      t.string :callback

      t.timestamps
    end
  end
end
