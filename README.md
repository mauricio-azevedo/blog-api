# Blog API

This is a Blog API application built with Ruby on Rails. It includes user authentication, posts, and comments functionality, and responds with JSON formatted data.

## Table of Contents

1. [Ruby Version](#ruby-version)
2. [System Dependencies](#system-dependencies)
3. [Configuration](#configuration)
4. [Database Creation](#database-creation)
5. [Running the Test Suite](#running-the-test-suite)
6. [Deployment Instructions](#deployment-instructions)
7. [API Endpoints](#api-endpoints)
7. [Authentication](#authentication)

***

## Ruby Version
- Ruby 3.3.4
- Rails 7.1.3.4

***

## System Dependencies
- `libpq-dev` (required for the `pg` gem)

***

## Configuration
Clone the repository and install dependencies:
```sh
git clone https://github.com/your-username/blog_api.git
cd blog_api
bundle install
```

***

## Database Creation
Database creation and initialization are not necessary as the database is hosted externally.

***

## Running the Test Suite
The application uses RSpec for testing.

- **Run all tests**:
  ```sh
  bundle exec rspec
  ```

- **Run a specific test file**:
  ```sh
  bundle exec rspec spec/requests/posts_controller_spec.rb
  ```

***

## Deployment Instructions
- ### Running Locally
  **Start the Rails server**:
  ```sh
  rails server
  ```
  The application will be available at http://localhost:3000.

- ### Running in Production
  The application includes a Dockerfile for containerized deployment.

***

## API Endpoints
- ### Authentication
  1. #### Sign up: `POST /users`
      **Parameters**:
      ```json
      {
        "user": {
          "name": "string",
          "name": "string",
          "password": "string",
          "password_confirmation": "string"
        }
      }
      ```

      **Response**:
      ```json
      {
        "message": "Signed up successfully",
        "ok": true, 
        "data": {
          "user": {
            "id": 1, 
            "email": "user@example.com", 
            "name": "User", 
            "created_at": "2023-07-20T08:00:00Z", 
            "updated_at": "2023-07-20T08:00:00Z"
          },
          "token": "eyJhbGciOiJIUzI1NiJ9..."
        },
        "details": []
      }
      ```
   
      <br>
   
  2. #### Sign in: `POST /users/sign_in`
      **Parameters**:
      ```json
      {
        "user": {
          "email": "string",
          "password": "string"
        }
      }
      ```

      **Response**:
      ```json
      {
        "message": "Signed in successfully",
        "ok": true,
        "data": {
          "user": {
            "id": 1, 
            "email": "user@example.com", 
            "name": "User", 
            "created_at": "2023-07-20T08:00:00Z", 
            "updated_at": "2023-07-20T08:00:00Z"
          },
          "token": "eyJhbGciOiJIUzI1NiJ9..."
        },
        "details": []
      }
      ```

     <br>

- ### Posts
  1. #### List all posts: `GET /posts`
      **Response**:
      ```json
      {
        "message": "Posts retrieved successfully",
        "ok": true,
        "data": [
          {
            "id": 6,
            "title": "A Post",
            "body": "A cool post",
            "user_id": 12,
            "created_at": "2024-07-21T05:29:37.989Z",
            "updated_at": "2024-07-21T05:29:37.989Z",
            "user": {
              "id": 12,
              "name": "Maurício Azevedo",
              "email": "mauricio.mendonca.azevedo+5@gmail.com",
              "created_at": "2024-07-20T07:45:49.236Z",
              "updated_at": "2024-07-20T07:45:49.236Z"
            },
            "comments": [
              {
                "id": 6,
                "body": "First edited 1",
                "post_id": 6,
                "user_id": 12,
                "created_at": "2024-07-21T08:06:58.558Z",
                "updated_at": "2024-07-21T15:56:47.289Z",
                "user": {
                  "id": 12,
                  "name": "Maurício Azevedo",
                  "email": "mauricio.mendonca.azevedo+5@gmail.com",
                  "created_at": "2024-07-20T07:45:49.236Z",
                  "updated_at": "2024-07-20T07:45:49.236Z"
                }
              }
            ]
          }
        ],
        "details": []
      }
      ```

     <br>

  2. #### Get a specific post: `GET /posts/:id`
      **Response**:
      ```json
      {
        "message": "Post retrieved successfully",
        "ok": true,
        "data": {
          "id": 1,
          "title": "Sample Post",
          "body": "This is a sample post",
          "created_at": "2023-07-20T08:00:00Z",
          "updated_at": "2023-07-20T08:00:00Z"
        },
        "details": []
      }
     ```

     <br>

  3. #### Create a new post: `POST /posts`
      **Parameters**:
      ```json
      {
        "post": {
          "body": "string",
          "title": "string"
        }
      }
      ```

      **Response**:
      ```json
      {
        "message": "Post retrieved successfully",
        "ok": true,
        "data": {
          "id": 1,
          "title": "Sample Post",
          "body": "This is a sample post",
          "created_at": "2023-07-20T08:00:00Z",
          "updated_at": "2023-07-20T08:00:00Z"
        },
        "details": []
      }
     ```

     <br>

  4. #### Update a post: `PUT /posts/:id`
      **Parameters**:
      ```json
      {
        "post": {
          "body": "string",
          "title": "string"
        }
      }
      ```

      **Response**:
      ```json
      {
        "message": "Post updated successfully",
        "ok": true,
        "data": {
          "id": 1,
          "title": "Updated Title",
          "body": "Updated body",
          "created_at": "2023-07-20T08:00:00Z",
          "updated_at": "2023-07-20T08:00:00Z"
        },
        "details": []
      }
      ```

     <br>

  5. #### Delete a post: `DELETE /posts/:id`
      **Response**:
      ```json
      {
        "message": "Post deleted successfully",
        "ok": true,
        "details": []
      }
      ```

     <br>

- ### Comments

  1. #### List all comments from a post: `GET /posts/:post_id/comments`
      **Response**:
      ```json
      {
        "message": "Comments retrieved successfully",
        "ok": true,
        "data": [
          {
            "id": 1,
            "body": "This is a sample comment",
            "created_at": "2023-07-20T08:00:00Z",
            "updated_at": "2023-07-20T08:00:00Z"
          }
        ],
        "details": []
      }
      ```

     <br>

  2. #### Get a specific comment from a post: `GET /posts/:post_id/comments/:id`
      **Response**:
      ```json
      {
        "message": "Comment retrieved successfully",
        "ok": true,
        "data": {
          "id": 1,
          "body": "This is a sample comment",
          "created_at": "2023-07-20T08:00:00Z",
          "updated_at": "2023-07-20T08:00:00Z"
        },
        "details": []
      }
      ```

     <br>

  3. #### Create a new comment for a post: `POST /posts/:post_id/comments`
      **Parameters**:
      ```json
      {
        "comment": {
          "body": "string"
        }
      }
      ```

      **Response**:
      ```json
      {
        "message": "Comment created successfully",
        "ok": true,
        "data": {
          "id": 1,
          "body": "This is a sample comment",
          "created_at": "2023-07-20T08:00:00Z",
          "updated_at": "2023-07-20T08:00:00Z"
        },
        "details": []
      }
      ```

     <br>

  4. #### Update a comment from a post: `PUT /posts/:post_id/comments/:id`
      **Parameters**:
      ```json
      {
        "comment": {
          "body": "string"
        }
      }
      ```

      **Response**:
      ```json
      {
        "message": "Comment updated successfully",
        "ok": true,
        "data": {
          "id": 1,
          "body": "Updated comment",
          "created_at": "2023-07-20T08:00:00Z",
          "updated_at": "2023-07-20T08:00:00Z"
        },
        "details": []
      }
      ```

     <br>

  5. #### Delete a comment from a post: `DELETE /posts/:post_id/comments/:id`
      **Response**:
      ```json
      {
        "message": "Comment deleted successfully",
        "ok": true,
        "details": []
      }
      ```

***

## Authentication
For all authenticated requests, the token must be included in the `Authorization` header. The token should be prefixed with `Bearer `.

- ### Obtaining the Token
  You can obtain the token by signing up or signing in.

- ### Using the Token
  **Example**:
  ```
  curl -X GET http://localhost:3000/posts \
  -H "Authorization: Bearer your_jwt_token_here"
  ```

