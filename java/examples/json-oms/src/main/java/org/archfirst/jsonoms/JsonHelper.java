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

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.SerializationConfig;
import org.codehaus.jackson.map.annotate.JsonSerialize;

/**
 * JsonHelper
 *
 * @author Naresh Bhatia
 */
public class JsonHelper {

    // Shared instance of mapper for better performance
    // (mappers are thread-safe after configuration)
    private static ObjectMapper mapper = new ObjectMapper();
    
    static {
        mapper.configure(
                SerializationConfig.Feature.WRITE_DATES_AS_TIMESTAMPS, false);
        mapper.configure(
                SerializationConfig.Feature.INDENT_OUTPUT, true);
        mapper.getSerializationConfig().setSerializationInclusion(
                JsonSerialize.Inclusion.NON_NULL);
    }
    
    public static final ObjectMapper getMapper() {
        return mapper;
    }
    
    public static final String toJson(Object object) {
        try {
            return mapper.writeValueAsString(object);
        }
        catch (IOException e) {
            throw new RuntimeException("Failed to convert value as JSON string", e);
        }
    }   
}