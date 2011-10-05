/**
 * Copyright 2010 Archfirst
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
package org.archfirst.bfoms.infra.app;

import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.inject.Produces;

import org.dozer.DozerBeanMapper;
import org.dozer.Mapper;
import org.dozer.loader.api.BeanMappingBuilder;

/**
 * DozerMapperFactory
 *
 * @author Naresh Bhatia
 */
public class DozerMapperFactory {

    @Produces
    @ApplicationScoped
    public Mapper getMapper() {
        BeanMappingBuilder builder = new BeanMappingBuilder() {
            protected void configure() {

                mapping(org.archfirst.bfoms.domain.security.User.class,
                        org.archfirst.bfoms.webservice.security.User.class)
                    .fields("person.firstName", "firstName")
                    .fields("person.lastName", "lastName");

                mapping(org.archfirst.bfoms.domain.security.User.class,
                        org.archfirst.bfoms.jsonservice.User.class)
                    .fields("person.firstName", "firstName")
                    .fields("person.lastName", "lastName");
            }
        };        

        DozerBeanMapper mapper = new DozerBeanMapper();
        mapper.addMapping(builder);
        return mapper;
    }
}