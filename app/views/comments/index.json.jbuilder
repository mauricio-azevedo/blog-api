json.array! @comments do |comment|
  json.extract! comment, :id, :body, :created_at, :updated_at
  json.user do
    json.id comment.user.id
    json.email comment.user.email
  end
end
