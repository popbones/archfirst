This example shows how to do basic authentication.

Build the application as follows:

    > mvn clean package

In GlassFish, set up a jdbcRealm called "auth-example":
    Use instructions from bullsfirst install, including field values.
    (We use the bullsfirst OMS database for this example.)

Deploy the application to GlassFish:

    > mvn glassfish:deploy

First access the public page:

    http://localhost:8080/authentication-example

Note that a session is created when the browser accesses the site. This is
because we call request.getSession(true) in the BaseServlet. The session
lasts for the duration specified in web.xml (see <session-timeout>).

At this point you can add attributes to the session using request parameters,
e.g.

    http://localhost:8080/authentication-example?name=location&value=Boston
    http://localhost:8080/authentication-example?name=timezone&value=EST

Now access the private page:

    http://localhost:8080/authentication-example/private

You will be asked for a username and password. Enter a valid username/password
for a bullsfirst user. You will now be able to see the private page.