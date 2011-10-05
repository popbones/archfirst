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
package org.archfirst.authexample;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * BaseServlet
 *
 * @author Naresh Bhatia
 */
public class BaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger =
        LoggerFactory.getLogger(PublicServlet.class);
    private static String START_PAGE =
        "<!DOCTYPE html><html><head><title>Authentication Example</title></head><body><code>";
    private static String END_PAGE =
        "</code></body></html>";


    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
    {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(true);

        // print session info
        Date created = new Date(session.getCreationTime());
        Date accessed = new Date(session.getLastAccessedTime());
        out.println(START_PAGE);
        out.println("<b>" + getPageName() + " Page</b><br />");
        out.println("SessionId:&nbsp;" + session.getId() + "<br />");
        out.println("Created:&nbsp;&nbsp;&nbsp;" + created + "<br />");
        out.println("Accessed:&nbsp;&nbsp;" + accessed + "<br />");

        // set session info if needed
        String dataName = request.getParameter("name");
        if (dataName != null && dataName.length() > 0) {
            String dataValue = request.getParameter("value");
            session.setAttribute(dataName, dataValue);
        }

        // print session contents
        @SuppressWarnings("unchecked")
        Enumeration<String> e = session.getAttributeNames();
        while (e.hasMoreElements()) {
            String name = e.nextElement();
            String value = session.getAttribute(name).toString();
            out.println(name + " = " + value + "<br />");
        }
        out.println(END_PAGE);
    }
    
    protected String getPageName() {
        return "Base";
    }
}