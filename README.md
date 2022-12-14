# chat_api

## Description

A chat api system that allows creating new applications where each application will have a token(generated by the system) and a name(provided by the client).

The token is the identifier that devices use to send chats to that application.
Each application can have many chats. A chat has a number. Numbering of chats in
each application starts from 1 and no 2 chats in the same application may have the same
number.

The number of the chat is returned in the chat creation request. A chat
contains messages and messages have numbers that start from 1 for each chat.
The number of the message is returned in the message creation request.

The client should never see the ID of any of the entities. The client identifies the application by its token and the chat by its number along with the application token.

The chat system provides an endpoint for searching through messages of a specific chat. It's capable to partially match messages’ bodies.

The chat system provides an additional websocket endpoint to be able catch the creation of a new chat or a new message at real-time.

## Dependecies

- Docker installed on your local machine
- VS Code as recommended IDE for development

## Installation

- Make copy `.env.sample` file & rename it to `.env`
- Compose-up for `docker-compose.yml` file in project directory

## Unit Tests

RSPEC files are available for the system. To run them, just uncomment `bundle exec rspec` command from `docker-entrypoint.sh` file.

## API Endpoints

To be able to use any endpoint provided by the system, you must include the following authorization token in any request header:

`Header Key: API-Key`

`Header Value: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiQ2hhdFN5c3RlbSIsImV4cCI6MTY5ODYxMDg4Mn0.Lv17tkZZYSZyCEkYRsNkJEgwnuj-GDhOyTE2Is_Uhi4`

This token is generated using `rails console` with command: `JsonWebToken.encode(user: 'ChatSystem')`

For now, this static token is used for authorizing the access to endpoints, later it can be replaced by login/ authorization system which will generate the token itself to autorize users to access the endpoints.

### Applications

- Create Application:

  - **URL** : `/api/v1/applications`

  - **Method** : `POST`

  - **Request Body** : `{ "name": "app_name" }`

  - **Response** : `{ "data": { "application_token": "app_token", "name": "app_name", "chats_count": 0 } }`

- Get All Applications:

  - **URL** : `/api/v1/applications`

  - **Method** : `GET`

  - **Request Body** : `{}`

  - **Response** : `{ "data": [ { "application_token": "app_i_token", "name": "app_i_name", "chats_count": app_i_chat_counts }, ... ], "count": #_apps_in_systems }`

- Get Application:

  - **URL** : `/api/v1/applications/[app_token]`

  - **Method** : `GET`

  - **Request Body** : `{}`

  - **Response** : `{ "data": { "application_token": "app_token", "name": "app_name", "chats_count": #_of_chats } }`

- Edit Application:

  - **URL** : `/api/v1/applications/[app_token]`

  - **Method** : `PUT`

  - **Request Body** : `{ "name": 'new_app_name' }`

  - **Response** : `{ "data": { "application_token": "app_token", "name": "new_app_name", "chats_count": #_of_chats } }`

### Chats

- Create Chat for Applcaction:

  - **URL** : `/api/v1/applications/[app_token]/chats`

  - **Method** : `POST`

  - **Request Body** : `{}`

  - **Response** :`{ "data": { "chat_number": chat_#, "messages_count": 0 } }`

- Get Chats for Application:

  - **URL** : `/api/v1/applications/[app_token]/chats`

  - **Method** : `GET`

  - **Request Body** : `{}`

  - **Response** : `{ "data": [ { "chat_number": chat_i_#, "messages_count": chat_i_msg_counts }, ... ], "count": #chats_app_i }`

- Get Chat by Number:

  - **URL** : `/api/v1/applications/[app_token]/chats/[chat_number]`

  - **Method** : `GET`

  - **Request Body** : `{}`

  - **Response** : `{ "data": { "chat_number": chat_#, "messages_count": chat_count } }`

### Messages

- Create Message:

  - **URL** : `/api/v1/applications/[app_token]/chats/[chat_number]/messages`

  - **Method** : `POST`

  - **Request Body** : `{ "message_content": "msg_text" }`

  - **Response** : `{ "data": { "message_number": msg_num, "message_content": "msg_text" } }`

- Get Messages for a Chat:

  - **URL** : `/api/v1/applications/[app_token]/chats/[chat_number]/messages`

  - **Method** : `GET`

  - **Request Body** : `{ "data": [ { "message_number": msg_i_num, "message_content": "msg_i_text" }, ... ], "count": msgs_count }`

- Get Message by Number:

  - **URL** : `/api/v1/applications/[app_token]/chats/[chat_number]/messages/[message_number]`

  - **Method** : `GET`

  - **Request Body** : `{}`

  - **Response** : `{ "data": { "message_number": msg_num, "message_content": "msg_text" } }`

- Search message body:

  - **URL** : `/api/v1/applications/[app_token]/chats/[chat_number]/messages/search?search_content=[search_text]`

  - **Method** : `GET`

  - **Request Body** : `{}`

  - **Response** : `{ "data": [ { "message_number": msg_i_num, "message_content": "msg_i_text" }..] }`

### Sockets

- Listen for **creation of new chats** in application:

  - Connect via a websocket to `/cable?application_token=[app_token]`

  - Press connect. Should connect succesfully.

  - In socket message section, subscribe for ApplicationChannel via `{"command":"subscribe","identifier":"{\"channel\":\"ApplicationChannel\"}"}`

  - When a new chat is created, the socket recieves it instantenously in the following format:
    `{ "identifier": "{\"channel\":\"ApplicationChannel\"}", "message": { "application": { "application_token": "app_token", "name": "app_name", "chats_count": app_chat_counts }, "chat_no": created_chat_num } }`

- Listen for **creation of new messages** in chat:

  - Connect via a websocket to `/cable?application_token=[app_token]`

  - Press connect. Should connect succesfully.

  - In socket message section, listen for ApplicationChannel via `{"command":"subscribe","identifier":"{\"channel\":\"ChatChannel\"}"}`

  - When a new message is created, the socket recieves it instantenously in the following format:
    `{ "identifier": "{\"channel\":\"ChatChannel\"}", "message": { "application": { "application_token": "app_token", "name": "app_name", "chats_count": app_chat_counts }, "chat_number": _chat_num, "message_no": new_msg_num, "message_content": "new_msg_text" } }`

### Postman Collection

- HTTP Endpoints collection is found [here](https://github.com/adelmeleka/chat_api/blob/main/docs/postman_collection.json)

## Technical Remarks

### Database Structure

<img src="https://github.com/adelmeleka/chat_api/blob/main/docs/ERD.png" width="600" height="400" />

### Handling Concurrency

Creating new chats/messages endpoints doesn't hit the MySQL database directly in order to avoid high traffic on the database or any potential race condition on high load.

Instead, creation of a new chat/message if done in a background job using sidekiq.
Handling the values `msgs_count` and `chats_count` for each application & chat are done by caching them in redis & using/updating them when needed.

To improve create/retrieve performance also, a caching mechanism is done on each chat/message newly created/retrieved from database. So first we check in redis if we have the needed chat/message before hitting the database. And when we hit the database & get it, we save it in redis for possible later use.

Cached chats/messages in redis expires every hour to ensure not having stale data too much.

## Improvements

- Use `elastic-search` gem to provide performance & security boost when searching between messages for a match.
- Implement rspec controllers tests for chats and messages -BONUS-.

## Contributor

Adel Atef Meleka
