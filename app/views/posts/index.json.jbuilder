json.array! @posts do |post|
  json.extract! post, :id, :title, :body, :created_at, :updated_at
  json.user do
    json.id post.user.id
    json.email post.user.email
  end
end
