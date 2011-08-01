/**
 * Copyright 2011 Archfirst
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.archfirst.jsonoms;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Accepts an order using an AJAX request and returns a JSON response
 * 
 * @author Naresh Bhatia
 */
public class AjaxOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger =
        LoggerFactory.getLogger(AjaxOrderServlet.class);
    private static int nextId = 1;

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String symbol = request.getParameter("symbol");
        String action = request.getParameter("action");
        String quantity = request.getParameter("quantity");
        if (symbol == null || action == null || quantity == null ||
            symbol.isEmpty() || action.isEmpty() || quantity.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        PrintWriter out = null;
        try {
            // Write response
            response.setContentType("application/json");
            out = response.getWriter();

            Order order =
                new Order(nextId++, action, symbol, Integer.parseInt(quantity));
            out.println(JsonHelper.toJson(order));

            out.flush();
        }
        catch (IOException e) {
            throw new RuntimeException("Failed to place order");
        }
        finally {
            if (out != null) out.close();
        }
    }
}