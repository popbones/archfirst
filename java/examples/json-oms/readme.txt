This example shows the difference between "traditional" HTML form processing
and AJAX based processing.

Build the application as follows:

    > mvn clean package

Execute the application as follows:

    > mvn jetty:run

To see HTML vs. AJAX based processing, visit the two URLs below:

    http://localhost:8080/json-oms/html-order.html
    http://localhost:8080/json-oms/ajax-order.html

HTML-based processing displays the order on a new page whereas AJAX-based
processing displays the order on the same page.