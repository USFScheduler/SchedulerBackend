class TasksController < ApplicationController
def create
    task = Task.new(task_params)
    if task.save
      render json: { message: 'Task created successfully', task: TaskSerializer.new(task).serialized_json }, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
def index
    tasks = Task.all
    render json: { tasks: TaskSerializer.new(tasks).serialized_json }, status: :ok
end
end