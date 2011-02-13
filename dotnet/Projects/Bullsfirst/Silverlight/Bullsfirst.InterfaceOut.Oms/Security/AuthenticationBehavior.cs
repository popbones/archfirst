using System.ComponentModel.Composition;
/* Copyright 2011 Archfirst
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
using System.ServiceModel.Channels;
using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;

namespace Bullsfirst.InterfaceOut.Oms.Security
{
    [Export]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class AuthenticationBehavior : IEndpointBehavior
    {
        private AuthenticationInspector _authenticationInspector;

        [ImportingConstructor]
        public AuthenticationBehavior(AuthenticationInspector authenticationInspector)
        {
            _authenticationInspector = authenticationInspector;

        }

        public void AddBindingParameters(ServiceEndpoint endpoint, BindingParameterCollection bindingParameters)
        {
        }

        public void ApplyClientBehavior(ServiceEndpoint endpoint, ClientRuntime clientRuntime)
        {
            clientRuntime.MessageInspectors.Add(_authenticationInspector);
        }

        public void ApplyDispatchBehavior(ServiceEndpoint endpoint, EndpointDispatcher endpointDispatcher)
        {
        }

        public void Validate(ServiceEndpoint endpoint)
        {
        }
    }

    [Export]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class AuthenticationInspector : IClientMessageInspector
    {
        private UserContext _userContext;

        [ImportingConstructor]
        public AuthenticationInspector(UserContext userContext)
        {
            _userContext = userContext;
        }

        public object BeforeSendRequest(ref Message request, System.ServiceModel.IClientChannel channel)
        {
            // Add username and password to HTTP headers
            HttpRequestMessageProperty httpRequestMessage = new HttpRequestMessageProperty();
            httpRequestMessage.Headers["username"] = _userContext.Credentials.Username;
            httpRequestMessage.Headers["password"] = _userContext.Credentials.Password;
            request.Properties.Add(HttpRequestMessageProperty.Name, httpRequestMessage);

            // Add username and password to SOAP headers
            // request.Headers.Add(MessageHeader.CreateHeader("username", "", _userContext.Credentials.Username));
            // request.Headers.Add(MessageHeader.CreateHeader("password", "", _userContext.Credentials.Password));

            return null;
        }

        public void AfterReceiveReply(ref Message reply, object correlationState)
        {
        }
    }
}