# TransactionsMono

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## If you have postman please download the file mono.postman_collection.json

## Enpoints
___
AUTH

POST http://localhost:4000/api/sign_in

```
{
    "email": "example@example.com",
    "password": "password"
}
```
___
MAKE TRANSACTIONS

HEADERS

authorization | bearer TOKEN

POST http://localhost:4000/api/transactions

```
{
    "transaction": {
        "amount": 15000,
        "description": "pago",
        "user_from_id": 2,
        "user_to_id": 1
    }
}
```

___

GET TRANSACTIONS BY USER_ID

HEADERS

authorization | bearer TOKEN

POST http://localhost:4000/api/user/:ID/transactions

___
