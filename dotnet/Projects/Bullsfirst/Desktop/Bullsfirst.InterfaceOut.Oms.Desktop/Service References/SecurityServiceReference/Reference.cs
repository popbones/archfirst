﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.1
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Bullsfirst.InterfaceOut.Oms.SecurityServiceReference {
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://archfirst.org/bfoms/securityservice.wsdl")]
    public partial class UsernameExistsException : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string messageField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string message {
            get {
                return this.messageField;
            }
            set {
                this.messageField = value;
                this.RaisePropertyChanged("message");
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://archfirst.org/bfoms/securityservice.wsdl")]
    public partial class RegistrationRequest : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string firstNameField;
        
        private string lastNameField;
        
        private string usernameField;
        
        private string passwordField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string FirstName {
            get {
                return this.firstNameField;
            }
            set {
                this.firstNameField = value;
                this.RaisePropertyChanged("FirstName");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public string LastName {
            get {
                return this.lastNameField;
            }
            set {
                this.lastNameField = value;
                this.RaisePropertyChanged("LastName");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=2)]
        public string Username {
            get {
                return this.usernameField;
            }
            set {
                this.usernameField = value;
                this.RaisePropertyChanged("Username");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=3)]
        public string Password {
            get {
                return this.passwordField;
            }
            set {
                this.passwordField = value;
                this.RaisePropertyChanged("Password");
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://archfirst.org/bfoms/securityservice.wsdl")]
    public partial class User : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string usernameField;
        
        private string firstNameField;
        
        private string lastNameField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string Username {
            get {
                return this.usernameField;
            }
            set {
                this.usernameField = value;
                this.RaisePropertyChanged("Username");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public string FirstName {
            get {
                return this.firstNameField;
            }
            set {
                this.firstNameField = value;
                this.RaisePropertyChanged("FirstName");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=2)]
        public string LastName {
            get {
                return this.lastNameField;
            }
            set {
                this.lastNameField = value;
                this.RaisePropertyChanged("LastName");
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://archfirst.org/bfoms/securityservice.wsdl")]
    public partial class AuthenticationResponse : object, System.ComponentModel.INotifyPropertyChanged {
        
        private bool successField;
        
        private User userField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public bool Success {
            get {
                return this.successField;
            }
            set {
                this.successField = value;
                this.RaisePropertyChanged("Success");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public User User {
            get {
                return this.userField;
            }
            set {
                this.userField = value;
                this.RaisePropertyChanged("User");
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(Namespace="http://archfirst.org/bfoms/securityservice.wsdl", ConfigurationName="SecurityServiceReference.SecurityWebService")]
    public interface SecurityWebService {
        
        // CODEGEN: Parameter 'AuthenticationResponse' requires additional schema information that cannot be captured using the parameter mode. The specific attribute is 'System.Xml.Serialization.XmlElementAttribute'.
        [System.ServiceModel.OperationContractAttribute(Action="AuthenticateUser", ReplyAction="http://archfirst.org/bfoms/securityservice.wsdl/SecurityWebService/AuthenticateUs" +
            "erResponse")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        [return: System.ServiceModel.MessageParameterAttribute(Name="AuthenticationResponse")]
        Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserResponse AuthenticateUser(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserRequest request);
        
        [System.ServiceModel.OperationContractAttribute(AsyncPattern=true, Action="AuthenticateUser", ReplyAction="http://archfirst.org/bfoms/securityservice.wsdl/SecurityWebService/AuthenticateUs" +
            "erResponse")]
        System.IAsyncResult BeginAuthenticateUser(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserRequest request, System.AsyncCallback callback, object asyncState);
        
        Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserResponse EndAuthenticateUser(System.IAsyncResult result);
        
        // CODEGEN: Parameter 'RegistrationRequest' requires additional schema information that cannot be captured using the parameter mode. The specific attribute is 'System.Xml.Serialization.XmlElementAttribute'.
        [System.ServiceModel.OperationContractAttribute(Action="RegisterUser", ReplyAction="http://archfirst.org/bfoms/securityservice.wsdl/SecurityWebService/RegisterUserRe" +
            "sponse")]
        [System.ServiceModel.FaultContractAttribute(typeof(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.UsernameExistsException), Action="http://archfirst.org/bfoms/securityservice.wsdl/SecurityWebService/RegisterUser/F" +
            "ault/UsernameExistsException", Name="UsernameExistsException")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserResponse RegisterUser(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserRequest request);
        
        [System.ServiceModel.OperationContractAttribute(AsyncPattern=true, Action="RegisterUser", ReplyAction="http://archfirst.org/bfoms/securityservice.wsdl/SecurityWebService/RegisterUserRe" +
            "sponse")]
        System.IAsyncResult BeginRegisterUser(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserRequest request, System.AsyncCallback callback, object asyncState);
        
        Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserResponse EndRegisterUser(System.IAsyncResult result);
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="AuthenticateUser", WrapperNamespace="http://archfirst.org/bfoms/securityservice.wsdl", IsWrapped=true)]
    public partial class AuthenticateUserRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://archfirst.org/bfoms/securityservice.wsdl", Order=0)]
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public string Username;
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://archfirst.org/bfoms/securityservice.wsdl", Order=1)]
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public string Password;
        
        public AuthenticateUserRequest() {
        }
        
        public AuthenticateUserRequest(string Username, string Password) {
            this.Username = Username;
            this.Password = Password;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="AuthenticateUserResponse", WrapperNamespace="http://archfirst.org/bfoms/securityservice.wsdl", IsWrapped=true)]
    public partial class AuthenticateUserResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://archfirst.org/bfoms/securityservice.wsdl", Order=0)]
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticationResponse AuthenticationResponse;
        
        public AuthenticateUserResponse() {
        }
        
        public AuthenticateUserResponse(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticationResponse AuthenticationResponse) {
            this.AuthenticationResponse = AuthenticationResponse;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="RegisterUser", WrapperNamespace="http://archfirst.org/bfoms/securityservice.wsdl", IsWrapped=true)]
    public partial class RegisterUserRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://archfirst.org/bfoms/securityservice.wsdl", Order=0)]
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegistrationRequest RegistrationRequest;
        
        public RegisterUserRequest() {
        }
        
        public RegisterUserRequest(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegistrationRequest RegistrationRequest) {
            this.RegistrationRequest = RegistrationRequest;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="RegisterUserResponse", WrapperNamespace="http://archfirst.org/bfoms/securityservice.wsdl", IsWrapped=true)]
    public partial class RegisterUserResponse {
        
        public RegisterUserResponse() {
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface SecurityWebServiceChannel : Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class AuthenticateUserCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        public AuthenticateUserCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        public Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticationResponse Result {
            get {
                base.RaiseExceptionIfNecessary();
                return ((Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticationResponse)(this.results[0]));
            }
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class SecurityWebServiceClient : System.ServiceModel.ClientBase<Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService>, Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService {
        
        private BeginOperationDelegate onBeginAuthenticateUserDelegate;
        
        private EndOperationDelegate onEndAuthenticateUserDelegate;
        
        private System.Threading.SendOrPostCallback onAuthenticateUserCompletedDelegate;
        
        private BeginOperationDelegate onBeginRegisterUserDelegate;
        
        private EndOperationDelegate onEndRegisterUserDelegate;
        
        private System.Threading.SendOrPostCallback onRegisterUserCompletedDelegate;
        
        public SecurityWebServiceClient() {
        }
        
        public SecurityWebServiceClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public SecurityWebServiceClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public SecurityWebServiceClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public SecurityWebServiceClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public event System.EventHandler<AuthenticateUserCompletedEventArgs> AuthenticateUserCompleted;
        
        public event System.EventHandler<System.ComponentModel.AsyncCompletedEventArgs> RegisterUserCompleted;
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserResponse Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService.AuthenticateUser(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserRequest request) {
            return base.Channel.AuthenticateUser(request);
        }
        
        public Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticationResponse AuthenticateUser(string Username, string Password) {
            Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserRequest inValue = new Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserRequest();
            inValue.Username = Username;
            inValue.Password = Password;
            Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserResponse retVal = ((Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService)(this)).AuthenticateUser(inValue);
            return retVal.AuthenticationResponse;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        System.IAsyncResult Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService.BeginAuthenticateUser(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserRequest request, System.AsyncCallback callback, object asyncState) {
            return base.Channel.BeginAuthenticateUser(request, callback, asyncState);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        public System.IAsyncResult BeginAuthenticateUser(string Username, string Password, System.AsyncCallback callback, object asyncState) {
            Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserRequest inValue = new Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserRequest();
            inValue.Username = Username;
            inValue.Password = Password;
            return ((Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService)(this)).BeginAuthenticateUser(inValue, callback, asyncState);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserResponse Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService.EndAuthenticateUser(System.IAsyncResult result) {
            return base.Channel.EndAuthenticateUser(result);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        public Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticationResponse EndAuthenticateUser(System.IAsyncResult result) {
            Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticateUserResponse retVal = ((Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService)(this)).EndAuthenticateUser(result);
            return retVal.AuthenticationResponse;
        }
        
        private System.IAsyncResult OnBeginAuthenticateUser(object[] inValues, System.AsyncCallback callback, object asyncState) {
            string Username = ((string)(inValues[0]));
            string Password = ((string)(inValues[1]));
            return this.BeginAuthenticateUser(Username, Password, callback, asyncState);
        }
        
        private object[] OnEndAuthenticateUser(System.IAsyncResult result) {
            Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.AuthenticationResponse retVal = this.EndAuthenticateUser(result);
            return new object[] {
                    retVal};
        }
        
        private void OnAuthenticateUserCompleted(object state) {
            if ((this.AuthenticateUserCompleted != null)) {
                InvokeAsyncCompletedEventArgs e = ((InvokeAsyncCompletedEventArgs)(state));
                this.AuthenticateUserCompleted(this, new AuthenticateUserCompletedEventArgs(e.Results, e.Error, e.Cancelled, e.UserState));
            }
        }
        
        public void AuthenticateUserAsync(string Username, string Password) {
            this.AuthenticateUserAsync(Username, Password, null);
        }
        
        public void AuthenticateUserAsync(string Username, string Password, object userState) {
            if ((this.onBeginAuthenticateUserDelegate == null)) {
                this.onBeginAuthenticateUserDelegate = new BeginOperationDelegate(this.OnBeginAuthenticateUser);
            }
            if ((this.onEndAuthenticateUserDelegate == null)) {
                this.onEndAuthenticateUserDelegate = new EndOperationDelegate(this.OnEndAuthenticateUser);
            }
            if ((this.onAuthenticateUserCompletedDelegate == null)) {
                this.onAuthenticateUserCompletedDelegate = new System.Threading.SendOrPostCallback(this.OnAuthenticateUserCompleted);
            }
            base.InvokeAsync(this.onBeginAuthenticateUserDelegate, new object[] {
                        Username,
                        Password}, this.onEndAuthenticateUserDelegate, this.onAuthenticateUserCompletedDelegate, userState);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserResponse Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService.RegisterUser(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserRequest request) {
            return base.Channel.RegisterUser(request);
        }
        
        public void RegisterUser(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegistrationRequest RegistrationRequest) {
            Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserRequest inValue = new Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserRequest();
            inValue.RegistrationRequest = RegistrationRequest;
            Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserResponse retVal = ((Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService)(this)).RegisterUser(inValue);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        System.IAsyncResult Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService.BeginRegisterUser(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserRequest request, System.AsyncCallback callback, object asyncState) {
            return base.Channel.BeginRegisterUser(request, callback, asyncState);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        public System.IAsyncResult BeginRegisterUser(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegistrationRequest RegistrationRequest, System.AsyncCallback callback, object asyncState) {
            Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserRequest inValue = new Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserRequest();
            inValue.RegistrationRequest = RegistrationRequest;
            return ((Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService)(this)).BeginRegisterUser(inValue, callback, asyncState);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserResponse Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService.EndRegisterUser(System.IAsyncResult result) {
            return base.Channel.EndRegisterUser(result);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        public void EndRegisterUser(System.IAsyncResult result) {
            Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegisterUserResponse retVal = ((Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.SecurityWebService)(this)).EndRegisterUser(result);
        }
        
        private System.IAsyncResult OnBeginRegisterUser(object[] inValues, System.AsyncCallback callback, object asyncState) {
            Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegistrationRequest RegistrationRequest = ((Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegistrationRequest)(inValues[0]));
            return this.BeginRegisterUser(RegistrationRequest, callback, asyncState);
        }
        
        private object[] OnEndRegisterUser(System.IAsyncResult result) {
            this.EndRegisterUser(result);
            return null;
        }
        
        private void OnRegisterUserCompleted(object state) {
            if ((this.RegisterUserCompleted != null)) {
                InvokeAsyncCompletedEventArgs e = ((InvokeAsyncCompletedEventArgs)(state));
                this.RegisterUserCompleted(this, new System.ComponentModel.AsyncCompletedEventArgs(e.Error, e.Cancelled, e.UserState));
            }
        }
        
        public void RegisterUserAsync(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegistrationRequest RegistrationRequest) {
            this.RegisterUserAsync(RegistrationRequest, null);
        }
        
        public void RegisterUserAsync(Bullsfirst.InterfaceOut.Oms.SecurityServiceReference.RegistrationRequest RegistrationRequest, object userState) {
            if ((this.onBeginRegisterUserDelegate == null)) {
                this.onBeginRegisterUserDelegate = new BeginOperationDelegate(this.OnBeginRegisterUser);
            }
            if ((this.onEndRegisterUserDelegate == null)) {
                this.onEndRegisterUserDelegate = new EndOperationDelegate(this.OnEndRegisterUser);
            }
            if ((this.onRegisterUserCompletedDelegate == null)) {
                this.onRegisterUserCompletedDelegate = new System.Threading.SendOrPostCallback(this.OnRegisterUserCompleted);
            }
            base.InvokeAsync(this.onBeginRegisterUserDelegate, new object[] {
                        RegistrationRequest}, this.onEndRegisterUserDelegate, this.onRegisterUserCompletedDelegate, userState);
        }
    }
}