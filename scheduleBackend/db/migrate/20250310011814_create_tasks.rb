class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.datetime :deadline
      t.integer :priority
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
