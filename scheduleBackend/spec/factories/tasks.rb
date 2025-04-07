# filepath: /home/daniellujo/SchedulerBackend/scheduleBackend/spec/factories/tasks.rb
FactoryBot.define do
    factory :task do
      title { "Sample Task" }
      start_time { "09:00" }
      end_time { "10:00" }
      am_start { true }
      am_end { true }
      days_of_week { ["M", "T"] }
    end
  end