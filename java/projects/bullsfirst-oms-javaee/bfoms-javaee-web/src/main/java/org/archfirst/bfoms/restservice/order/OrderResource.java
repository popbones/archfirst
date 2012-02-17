/**
 * Copyright 2012 Archfirst
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
package org.archfirst.bfoms.restservice.order;

import java.util.ArrayList;
import java.util.List;

import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import javax.ws.rs.core.UriInfo;

import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccountService;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderCriteria;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderParams;
import org.archfirst.bfoms.restservice.util.ErrorMessage;
import org.archfirst.bfoms.restservice.util.Link;
import org.dozer.Mapper;

/**
 * Order
 *
 * @author Naresh Bhatia
 */
@Stateless
@Path("/secure/orders")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class OrderResource {

    @POST
    public Response createOrder(
            @Context SecurityContext sc,
            CreateOrderRequest request) {
        
        try {
            Long id = brokerageAccountService.placeOrder(
                    getUsername(sc), request.getBrokerageAccountId(), request.getOrderParams());

            // Return link to self
            Link self = new Link(uriInfo, Long.toString(id));
            return Response.created(self.getUri()).entity(self).build();
        }
        catch (RuntimeException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorMessage(e.getMessage())).build();
        }
    }
    
    @POST
    @Path("{id}/cancel")
    public Response cancelOrder(
            @Context SecurityContext sc,
            @PathParam("id") Long id) {
        
        try {
            brokerageAccountService.cancelOrder(getUsername(sc), id);
        }
        catch (RuntimeException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorMessage(e.getMessage())).build();
        }

        return Response.ok().build();
    }
    
    @GET
    public List<Order> getOrders(
            @Context SecurityContext sc,
            @QueryParam("accountId") Long accountId) {
        
        OrderCriteria criteria = new OrderCriteria();
        if (accountId != null)
            criteria.setAccountId(accountId);
        List<org.archfirst.bfoms.domain.account.brokerage.order.Order> orders =
            this.brokerageAccountService.getOrders(getUsername(sc), criteria);
        List<Order> orderDtos = new ArrayList<Order>();
        for (org.archfirst.bfoms.domain.account.brokerage.order.Order order: orders) {
            orderDtos.add(mapper.map(order, Order.class));
        }
        return orderDtos;
    }
    
    private String getUsername(SecurityContext sc) {
        return sc.getUserPrincipal().getName();
    }

    // ----- Helper Classes -----
    private static class CreateOrderRequest {
        private Long brokerageAccountId;
        private OrderParams  orderParams;
        public Long getBrokerageAccountId() {
            return brokerageAccountId;
        }
        public void setBrokerageAccountId(Long brokerageAccountId) {
            this.brokerageAccountId = brokerageAccountId;
        }
        public OrderParams getOrderParams() {
            return orderParams;
        }
        public void setOrderParams(OrderParams orderParams) {
            this.orderParams = orderParams;
        }
    }

    // ----- Attributes -----
    @Context
    private UriInfo uriInfo;

    @Inject
    private BrokerageAccountService brokerageAccountService;
    
    @Inject
    private Mapper mapper;
}