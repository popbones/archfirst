This example shows how to implement a RESTful API using JAX-RS and JSON.
We also demonstrate how such an API could be consumed by a Web application
using the Backbone.js library (see http://backbonejs.org).

The example implements a very simple Order Management System (OMS) with
only one entity called Order. An Order has the following attributes:

    id: a unique identifier
    side: "Buy" or "Sell"
    symbol: identifier of the security being bought or sold
    quantity: quantity being bought or sold
    self: URI to access this order over http

The RESTful API is specified in the docs folder.

Use Maven to build the application:

    > mvn clean package

Execute the application using the jetty plugin:

    > mvn jetty:run

You could also drop the build application (target/jaxrs-oms.war) in
a JavaEE compliant server such as Tomcat, JBoss AS or GlassFish.

The front-end can now be accessed at the following URL:

    http://localhost:8080