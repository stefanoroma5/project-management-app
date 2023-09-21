json.extract! task, :id, :start_date, :end_date, :status, :description, :task_type, :estimation, :priority, :title, :created_at, :updated_at
json.url task_url(task, format: :json)
