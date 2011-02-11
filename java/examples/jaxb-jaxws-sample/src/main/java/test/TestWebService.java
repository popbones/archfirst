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
package test;

import javax.jws.WebMethod;
import javax.jws.WebResult;
import javax.jws.WebService;

/**
 * TestWebService
 *
 * @author Naresh Bhatia
 */
@WebService(targetNamespace = "http://proj3/testservice.wsdl", serviceName = "TestService")
public class TestWebService {

    @WebMethod(operationName = "GetPosition", action = "GetPosition")
    @WebResult(name = "Position")
    public Position GetPosition() {
        return new Position(new DecimalQuantity("10.2"));
    }
}