json.extract! project, :id, :title, :deadline, :customer, :description, :status, :start_date, :end_date, :created_at, :updated_at
json.url project_url(project, format: :json)
