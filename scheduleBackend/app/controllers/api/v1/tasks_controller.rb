# app/controllers/api/v1/tasks_controller.rb
module Api
  module V1
    class TasksController < ApplicationController
      before_action :authorize_request
      before_action :set_task, only: [:show, :update, :destroy]

      def create
        tasks = params[:tasks]
        created_tasks = []

        tasks.each do |task_params|
          unless task_params.is_a?(Hash) || task_params.is_a?(ActionController::Parameters)
            render json: { errors: ["Invalid task format"] }, status: :unprocessable_entity and return
          end

          task_params = ActionController::Parameters.new(task_params) unless task_params.is_a?(ActionController::Parameters)

          task = Task.new(task_params.permit(:title, :start_time, :end_time, :am_start, :am_end, :user_id, days_of_week: []))

          if task.save
            created_tasks << task
          else
            render json: { errors: task.errors.full_messages }, status: :unprocessable_entity and return
          end
        end

        render json: { message: 'Tasks created successfully', tasks: created_tasks }, status: :created
      end

      def index
        tasks = Task.all
        render json: tasks, status: :ok
      end

      def show
        render json: @task, status: :ok
      end

      def task_by_user
        user_id = params[:user_id]
        tasks = Task.where(user_id: user_id)
        render json: tasks, status: :ok
      end

      def update
        if @task.update(task_params)
          render json: @task, status: :ok
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @task.destroy
          render json: { message: 'Task successfully deleted' }, status: :ok
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_task
        @task = Task.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Task not found' }, status: :not_found
      end

      def task_params
        params.require(:task).permit(:title, :start_time, :end_time, :am_start, :am_end, :user_id, days_of_week: [])
      end
    end
  end
end