class AddRefreshTokenExpiresAtToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :refresh_token_expires_at, :datetime
  end
end
