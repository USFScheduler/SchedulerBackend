class TaskSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :start_date, :end_date, :deadline, :priority, :user_id
end