class AddCanvasApiTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :canvas_api_token, :string
  end
end
