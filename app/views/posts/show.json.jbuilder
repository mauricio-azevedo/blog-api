json.extract! @post, :id, :title, :body, :created_at, :updated_at
json.user do
  json.id @post.user.id
  json.email @post.user.email
end
json.comments @post.comments do |comment|
  json.extract! comment, :id, :body, :created_at, :updated_at
  json.user do
    json.id comment.user.id
    json.email comment.user.email
  end
end
