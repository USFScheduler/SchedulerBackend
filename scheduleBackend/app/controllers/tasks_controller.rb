# filepath: /home/daniellujo/SchedulerBackend/scheduleBackend/app/controllers/tasks_controller.rb
class TasksController < ApplicationController
    def create
      # Extract the array of tasks from the request
      tasks = params[:tasks]
  
      # Initialize an array to store successfully created tasks
      created_tasks = []
  
      # Iterate over each task and attempt to save it
      tasks.each do |task_params|
        task = Task.new(task_params.permit(:title, :start_time, :end_time, :am_start, :am_end, days_of_week: []))
        if task.save
          created_tasks << task
        else
          # If any task fails, return an error response
          render json: { errors: task.errors.full_messages }, status: :unprocessable_entity and return
        end
      end
  
      # If all tasks are successfully created, return a success response
      render json: { message: 'Tasks created successfully', tasks: created_tasks }, status: :created
    end
  
    def index
      # Return all tasks
      tasks = Task.all
      render json: tasks, status: :ok
    end
  
    private
  
    # Strong parameters to permit the attributes sent by the frontend
    def task_params
      params.require(:task).permit(:title, :start_time, :end_time, :am_start, :am_end, days_of_week: [])
    end
  end