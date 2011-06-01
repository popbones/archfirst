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
package org.archfirst.bfcommon.jsontrading;

import java.io.IOException;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.SerializationConfig;

/**
 * JsonMessageMapper
 *
 * @author Naresh Bhatia
 */
public class JsonMessageMapper {
    
    // Shared instances of mapper for performance
    // (mappers are thread-safe after configuration)
    private static ObjectMapper mapper = new ObjectMapper();
    private static ObjectMapper prettyMapper = new ObjectMapper();
    
    static {
        mapper.configure(
                SerializationConfig.Feature.WRITE_DATES_AS_TIMESTAMPS, false);
        prettyMapper.configure(
                SerializationConfig.Feature.WRITE_DATES_AS_TIMESTAMPS, false);
        prettyMapper.configure(
                SerializationConfig.Feature.INDENT_OUTPUT, true);
    }
    
    public String toString(JsonMessage jsonMessage) {
        try {
            return mapper.writeValueAsString(jsonMessage);
        }
        catch (JsonGenerationException e) {
            throw new RuntimeException("Failed to convert to string", e);
        }
        catch (JsonMappingException e) {
            throw new RuntimeException("Failed to convert to string", e);
        }
        catch (IOException e) {
            throw new RuntimeException("Failed to convert to string", e);
        }
    }
    
    public String toFormattedString(JsonMessage jsonMessage) {
        try {
            return prettyMapper.writeValueAsString(jsonMessage);
        }
        catch (JsonGenerationException e) {
            throw new RuntimeException("Failed to convert to string", e);
        }
        catch (JsonMappingException e) {
            throw new RuntimeException("Failed to convert to string", e);
        }
        catch (IOException e) {
            throw new RuntimeException("Failed to convert to string", e);
        }
    }
    
    public JsonMessage fromString(String messageText) {

        try {
            // Read the message text into a JsonNode tree
            JsonNode rootNode =
                mapper.readValue(messageText, JsonNode.class);
            
            // Extract the message type
            MessageType messageType =
                MessageType.valueOf(rootNode.path("messageType").getTextValue());
            
            // Extract the payload based on the message type
            Object payload = null;
            switch(messageType) {
                case NewOrderSingle:
                    payload = mapper.readValue(
                            rootNode.path("payload"), NewOrderSingle.class);
                    break;
                case ExecutionReport:
                    payload = mapper.readValue(
                            rootNode.path("payload"), ExecutionReport.class);
                    break;
                case OrderCancelRequest:
                    payload = mapper.readValue(
                            rootNode.path("payload"), OrderCancelRequest.class);
                    break;
                case OrderCancelReject:
                    payload = mapper.readValue(
                            rootNode.path("payload"), OrderCancelReject.class);
                    break;
            }

            return new JsonMessage(messageType, payload);
        }
        catch (JsonGenerationException e) {
            throw new RuntimeException("Failed to convert to string", e);
        }
        catch (JsonMappingException e) {
            throw new RuntimeException("Failed to convert to string", e);
        }
        catch (IOException e) {
            throw new RuntimeException("Failed to convert to string", e);
        }
    }
}