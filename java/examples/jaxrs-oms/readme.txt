This example shows how to create and get orders using a RESTful api. We use
JAX-RS and JSON to achieve this.

Build the application as follows:

    > mvn clean package

Execute the application as follows:

    > mvn jetty:run

Creating Orders
===============
POST http://localhost:8080/jaxrs-oms/rest/orders HTTP/1.1

{
    "id": "123",
    "symbol": "AAPL",
    "side": "Buy",
    "quantity": "1000"
}

Getting Orders
==============
GET http://localhost:8080/jaxrs-oms/rest/orders/123 HTTP/1.1

Response:
{
    "id": "123",
    "symbol": "AAPL",
    "side": "Buy",
    "quantity": "1000"
}