# filepath: /home/daniellujo/SchedulerBackend/scheduleBackend/db/migrate/XXXXXXXXXXXXXX_change_user_id_to_be_nullable_in_tasks.rb
class ChangeUserIdToBeNullableInTasks < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tasks, :user_id, true
  end
end