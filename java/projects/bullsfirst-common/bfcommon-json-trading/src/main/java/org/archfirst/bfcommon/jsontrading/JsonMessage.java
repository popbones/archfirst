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

/**
 * JsonMessage
 *
 * @author Naresh Bhatia
 */
public class JsonMessage {
    
    private MessageType messageType;
    private Object payload;

    // ----- Constructor -----
    public JsonMessage() {
    }

    public JsonMessage(MessageType messageType, Object payload) {
        this.messageType = messageType;
        this.payload = payload;
    }

    // ----- Getters and Setters -----
    public MessageType getMessageType() {
        return messageType;
    }
    public void setMessageType(MessageType messageType) {
        this.messageType = messageType;
    }

    public Object getPayload() {
        return payload;
    }
    public void setPayload(Object payload) {
        this.payload = payload;
    }
}