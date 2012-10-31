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
package org.archfirst.jaxrsoms;

import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;

/**
 * OrderResource
 *
 * @author Naresh Bhatia
 */
@Path("/orders")
public class OrderResource {
    
    @Context UriInfo uriInfo;

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response createOrder(Order order) {
        OrderRepository.persist(order);
        order.setSelf(uriInfo.getAbsolutePathBuilder()
            .path(String.valueOf(order.getId()))
            .build());

        return Response.created(order.getSelf()).entity(order).build();
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Order> getOrders(@QueryParam("symbol") String symbol) {
        return OrderRepository.findOrders(symbol);
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("{id}")
    public Order getOrder(@PathParam("id") int id) {
        Order order = OrderRepository.find(id);
        if (order == null) {
            throw new WebApplicationException(Response.Status.NOT_FOUND);
        }
        return order;
    }

    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("{id}")
    public Order updateOrder(Order orderChangeRequest) {
        Order order = OrderRepository.find(orderChangeRequest.getId());
        if (order == null) {
            throw new WebApplicationException(Response.Status.NOT_FOUND);
        }
        
        // Only order quantity can be changed
        order.setQuantity(orderChangeRequest.getQuantity());
        return order;
    }

    @DELETE
    @Path("{id}")
    public Response deleteOrder(@PathParam("id") int id) {
        Order order = OrderRepository.delete(id);
        if (order == null) {
            throw new WebApplicationException(Response.Status.NOT_FOUND);
        }
        return Response.ok().build();
    }
}