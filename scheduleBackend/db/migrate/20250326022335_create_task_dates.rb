class CreateTaskDates < ActiveRecord::Migration[8.0]
  def change
    # Add NOT NULL constraint to the title column
    change_column_null :tasks, :title, false

    # Rename created_at and updated_at to start_time and end_time
    rename_column :tasks, :created_at, :start_time
    rename_column :tasks, :updated_at, :end_time

    # Change start_time and end_time to strings
    change_column :tasks, :start_time, :string
    change_column :tasks, :end_time, :string

    # Add days_of_week column as a comma-separated string
    add_column :tasks, :days_of_week, :text, default: ""

    # Add boolean columns for AM/PM indicators
    add_column :tasks, :am_start, :boolean, default: true
    add_column :tasks, :am_end, :boolean, default: true
  end
end