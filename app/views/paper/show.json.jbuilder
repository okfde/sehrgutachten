json.url paper_url(@department, @paper, format: :json)
json.html_url paper_url(@department, @paper)

json.reference @paper.reference

json.department do
  json.url department_url(@department, format: :json)
  json.html_url department_url(@department)
  json.short_name @department.short_name
  json.subject @department.subject
end

json.title @paper.title

json.created_at @paper.created_at
json.page_count @paper.page_count

json.contents_url paper_url(@department, @paper, format: :txt)
json.download_url @paper.url