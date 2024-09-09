# POST - Create a User by name

    Method: Post
    Endpoint: `http://<host>:<port>/api/users`
    BodyJSON: `{"display_name":"Andrew"}`

# GET - Retreive all Users

    Method: Get
    Endpoint: `http://<host>:<port>/api/users/all`

# DELETE - Remove a User by ID

    Method: Delete
    Endpoint: `http://<host>:<port>/api/users/id?id=<userid>`

# PUT - Update a User name by ID

    Method: Put
    Endpoint: `http://<host>:<port>/api/users/id`
    BodyJSON: `{"id": "1", "display_name":"Andrew"}`
