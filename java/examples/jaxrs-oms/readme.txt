This example shows how to create and get orders using a RESTful API. We use
JAX-RS and JSON to achieve this.

Build the application as follows:

    > mvn clean package

Execute the application as follows:

    > mvn jetty:run

Create an order
===============
POST http://localhost:8080/jaxrs-oms/rest/orders HTTP/1.1
Content-Type: application/json

{
    "symbol": "AAPL",
    "side": "Buy",
    "quantity": 1000
}

Response
--------
HTTP/1.1 201 Created
Location: http://localhost:8080/jaxrs-oms/rest/orders/1
Content-Type: application/json

{
    "id": 1,
    "symbol": "AAPL",
    "side": "Buy",
    "quantity": 1000,
    "self": "http://localhost:8080/jaxrs-oms/rest/orders/1"
}

Get a single order
==================
GET http://localhost:8080/jaxrs-oms/rest/orders/1 HTTP/1.1

Response
--------
HTTP/1.1 200 OK
Content-Type: application/json

{
    "id": 1,
    "symbol": "AAPL",
    "side": "Buy",
    "quantity": 1000,
    "self": "http://localhost:8080/jaxrs-oms/rest/orders/1"
}

Get all orders
==============
GET http://localhost:8080/jaxrs-oms/rest/orders HTTP/1.1

Response
--------
HTTP/1.1 200 OK
Content-Type: application/json

[{
    "id": 1,
    "symbol": "AAPL",
    "side": "Buy",
    "quantity": 1000,
    "self": "http://localhost:8080/jaxrs-oms/rest/orders/1"
},
{
    "id": 2,
    "symbol": "MSFT",
    "side": "Buy",
    "quantity": 500,
    "self": "http://localhost:8080/jaxrs-oms/rest/orders/2"
}]

Getting orders for the specified security
=========================================
GET http://localhost:8080/jaxrs-oms/rest/orders?symbol=AAPL HTTP/1.1

Response
--------
HTTP/1.1 200 OK
Content-Type: application/json

[{
    "id": 1,
    "symbol": "AAPL",
    "side": "Buy",
    "quantity": 1000,
    "self": "http://localhost:8080/jaxrs-oms/rest/orders/1"
}]

Update an order
===============
PUT http://localhost:8080/jaxrs-oms/rest/orders/1 HTTP/1.1
Content-Type: application/json

{
    "id": 1,
    "symbol": "AAPL",
    "side": "Buy",
    "quantity": 2000,
    "self": "http://localhost:8080/jaxrs-oms/rest/orders/1"
}

Response
--------
HTTP/1.1 200 OK
Content-Type: application/json

{
    "id": 1,
    "symbol": "AAPL",
    "side": "Buy",
    "quantity": 2000,
    "self": "http://localhost:8080/jaxrs-oms/rest/orders/1"
}

Delete an order
===============
DELETE http://localhost:8080/jaxrs-oms/rest/orders/1 HTTP/1.1

Response
--------
HTTP/1.1 200 OK