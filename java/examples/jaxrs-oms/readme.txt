This example shows the difference between "traditional" HTML form processing
and AJAX based processing. In the traditional approach each time a button
or hyperlink is clicked, a form post and a page reload are executed.
In the AJAX approach, the initial page is loaded once and then server requests
are made only when new data is required or updated. In addition, changes to
the page are made locally by the client.

Build the application as follows:

    > mvn clean package

Execute the application as follows:

    > mvn jetty:run

To see HTML vs. AJAX based processing, visit the two URLs below:

    http://localhost:8080/json-oms/html-order.html
    http://localhost:8080/json-oms/ajax-order.html

HTML-based processing does a full page reload to display the submitted order
whereas the AJAX-based page displays submitted orders on the same page.