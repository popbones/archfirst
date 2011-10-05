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
package org.archfirst.bfoms.jsonservice;

import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.archfirst.bfoms.domain.security.SecurityService;
import org.dozer.Mapper;

/**
 * Login
 *
 * @author Naresh Bhatia
 */
@Stateless
@Path("/login")
@Produces(MediaType.APPLICATION_JSON)
public class Login {

    @Inject
    private SecurityService securityService;
    
    @Inject
    private Mapper mapper;
    
    // ----- Commands -----

    // ----- Queries -----
    @GET
    public User getUser() {
        return mapper.map(
                securityService.getUser("jhorner"),
                User.class);
    }
}