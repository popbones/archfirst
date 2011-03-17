﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.1
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// 
// This code was auto-generated by Microsoft.Silverlight.ServiceReference, version 4.0.50826.0
// 
using System;
using System.ComponentModel.Composition;

namespace Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(Namespace="http://archfirst.org/bfexch/marketdataservice.wsdl", ConfigurationName="MarketDataServiceReference.MarketDataWebService")]
    public interface MarketDataWebService {
        
        [System.ServiceModel.OperationContractAttribute(AsyncPattern=true, Action="GetMarketPrices", ReplyAction="http://archfirst.org/bfexch/marketdataservice.wsdl/MarketDataWebService/GetMarket" +
            "PricesResponse")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        System.IAsyncResult BeginGetMarketPrices(Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPricesRequest request, System.AsyncCallback callback, object asyncState);
        
        Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPricesResponse EndGetMarketPrices(System.IAsyncResult result);
        
        [System.ServiceModel.OperationContractAttribute(AsyncPattern=true, Action="GetMarketPrice", ReplyAction="http://archfirst.org/bfexch/marketdataservice.wsdl/MarketDataWebService/GetMarket" +
            "PriceResponse")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        System.IAsyncResult BeginGetMarketPrice(Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceRequest request, System.AsyncCallback callback, object asyncState);
        
        Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceResponse EndGetMarketPrice(System.IAsyncResult result);
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.1")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://archfirst.org/bfexch/marketdataservice.wsdl")]
    public partial class MarketPrice : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string symbolField;
        
        private Money priceField;
        
        private System.DateTime effectiveField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string Symbol {
            get {
                return this.symbolField;
            }
            set {
                this.symbolField = value;
                this.RaisePropertyChanged("Symbol");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public Money Price {
            get {
                return this.priceField;
            }
            set {
                this.priceField = value;
                this.RaisePropertyChanged("Price");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=2)]
        public System.DateTime Effective {
            get {
                return this.effectiveField;
            }
            set {
                this.effectiveField = value;
                this.RaisePropertyChanged("Effective");
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
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://archfirst.org/bfexch/marketdataservice.wsdl")]
    public partial class Money : object, System.ComponentModel.INotifyPropertyChanged {
        
        private decimal amountField;
        
        private string currencyField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public decimal Amount {
            get {
                return this.amountField;
            }
            set {
                this.amountField = value;
                this.RaisePropertyChanged("Amount");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public string Currency {
            get {
                return this.currencyField;
            }
            set {
                this.currencyField = value;
                this.RaisePropertyChanged("Currency");
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
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="GetMarketPrices", WrapperNamespace="http://archfirst.org/bfexch/marketdataservice.wsdl", IsWrapped=true)]
    public partial class GetMarketPricesRequest {
        
        public GetMarketPricesRequest() {
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="GetMarketPricesResponse", WrapperNamespace="http://archfirst.org/bfexch/marketdataservice.wsdl", IsWrapped=true)]
    public partial class GetMarketPricesResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://archfirst.org/bfexch/marketdataservice.wsdl", Order=0)]
        [System.Xml.Serialization.XmlElementAttribute("MarketPrice", Form=System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public MarketPrice[] MarketPrice;
        
        public GetMarketPricesResponse() {
        }
        
        public GetMarketPricesResponse(MarketPrice[] MarketPrice) {
            this.MarketPrice = MarketPrice;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="GetMarketPrice", WrapperNamespace="http://archfirst.org/bfexch/marketdataservice.wsdl", IsWrapped=true)]
    public partial class GetMarketPriceRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://archfirst.org/bfexch/marketdataservice.wsdl", Order=0)]
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public string Symbol;
        
        public GetMarketPriceRequest() {
        }
        
        public GetMarketPriceRequest(string Symbol) {
            this.Symbol = Symbol;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="GetMarketPriceResponse", WrapperNamespace="http://archfirst.org/bfexch/marketdataservice.wsdl", IsWrapped=true)]
    public partial class GetMarketPriceResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://archfirst.org/bfexch/marketdataservice.wsdl", Order=0)]
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketPrice MarketPrice;
        
        public GetMarketPriceResponse() {
        }
        
        public GetMarketPriceResponse(Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketPrice MarketPrice) {
            this.MarketPrice = MarketPrice;
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface MarketDataWebServiceChannel : Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class GetMarketPricesCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        public GetMarketPricesCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        public MarketPrice[] Result {
            get {
                base.RaiseExceptionIfNecessary();
                return ((MarketPrice[])(this.results[0]));
            }
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class GetMarketPriceCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        public GetMarketPriceCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        public Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketPrice Result {
            get {
                base.RaiseExceptionIfNecessary();
                return ((Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketPrice)(this.results[0]));
            }
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class MarketDataWebServiceClient : System.ServiceModel.ClientBase<Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService>, Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService {
        
        private BeginOperationDelegate onBeginGetMarketPricesDelegate;
        
        private EndOperationDelegate onEndGetMarketPricesDelegate;
        
        private System.Threading.SendOrPostCallback onGetMarketPricesCompletedDelegate;
        
        private BeginOperationDelegate onBeginGetMarketPriceDelegate;
        
        private EndOperationDelegate onEndGetMarketPriceDelegate;
        
        private System.Threading.SendOrPostCallback onGetMarketPriceCompletedDelegate;
        
        private BeginOperationDelegate onBeginOpenDelegate;
        
        private EndOperationDelegate onEndOpenDelegate;
        
        private System.Threading.SendOrPostCallback onOpenCompletedDelegate;
        
        private BeginOperationDelegate onBeginCloseDelegate;
        
        private EndOperationDelegate onEndCloseDelegate;
        
        private System.Threading.SendOrPostCallback onCloseCompletedDelegate;
        
        public MarketDataWebServiceClient() {
        }
        
        public MarketDataWebServiceClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public MarketDataWebServiceClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public MarketDataWebServiceClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public MarketDataWebServiceClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public System.Net.CookieContainer CookieContainer {
            get {
                System.ServiceModel.Channels.IHttpCookieContainerManager httpCookieContainerManager = this.InnerChannel.GetProperty<System.ServiceModel.Channels.IHttpCookieContainerManager>();
                if ((httpCookieContainerManager != null)) {
                    return httpCookieContainerManager.CookieContainer;
                }
                else {
                    return null;
                }
            }
            set {
                System.ServiceModel.Channels.IHttpCookieContainerManager httpCookieContainerManager = this.InnerChannel.GetProperty<System.ServiceModel.Channels.IHttpCookieContainerManager>();
                if ((httpCookieContainerManager != null)) {
                    httpCookieContainerManager.CookieContainer = value;
                }
                else {
                    throw new System.InvalidOperationException("Unable to set the CookieContainer. Please make sure the binding contains an HttpC" +
                            "ookieContainerBindingElement.");
                }
            }
        }
        
        public event System.EventHandler<GetMarketPricesCompletedEventArgs> GetMarketPricesCompleted;
        
        public event System.EventHandler<GetMarketPriceCompletedEventArgs> GetMarketPriceCompleted;
        
        public event System.EventHandler<System.ComponentModel.AsyncCompletedEventArgs> OpenCompleted;
        
        public event System.EventHandler<System.ComponentModel.AsyncCompletedEventArgs> CloseCompleted;
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        System.IAsyncResult Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService.BeginGetMarketPrices(Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPricesRequest request, System.AsyncCallback callback, object asyncState) {
            return base.Channel.BeginGetMarketPrices(request, callback, asyncState);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        private System.IAsyncResult BeginGetMarketPrices(System.AsyncCallback callback, object asyncState) {
            Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPricesRequest inValue = new Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPricesRequest();
            return ((Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService)(this)).BeginGetMarketPrices(inValue, callback, asyncState);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPricesResponse Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService.EndGetMarketPrices(System.IAsyncResult result) {
            return base.Channel.EndGetMarketPrices(result);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        private MarketPrice[] EndGetMarketPrices(System.IAsyncResult result) {
            Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPricesResponse retVal = ((Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService)(this)).EndGetMarketPrices(result);
            return retVal.MarketPrice;
        }
        
        private System.IAsyncResult OnBeginGetMarketPrices(object[] inValues, System.AsyncCallback callback, object asyncState) {
            return this.BeginGetMarketPrices(callback, asyncState);
        }
        
        private object[] OnEndGetMarketPrices(System.IAsyncResult result) {
            MarketPrice[] retVal = this.EndGetMarketPrices(result);
            return new object[] {
                    retVal};
        }
        
        private void OnGetMarketPricesCompleted(object state) {
            if ((this.GetMarketPricesCompleted != null)) {
                InvokeAsyncCompletedEventArgs e = ((InvokeAsyncCompletedEventArgs)(state));
                this.GetMarketPricesCompleted(this, new GetMarketPricesCompletedEventArgs(e.Results, e.Error, e.Cancelled, e.UserState));
            }
        }
        
        public void GetMarketPricesAsync() {
            this.GetMarketPricesAsync(null);
        }
        
        public void GetMarketPricesAsync(object userState) {
            if ((this.onBeginGetMarketPricesDelegate == null)) {
                this.onBeginGetMarketPricesDelegate = new BeginOperationDelegate(this.OnBeginGetMarketPrices);
            }
            if ((this.onEndGetMarketPricesDelegate == null)) {
                this.onEndGetMarketPricesDelegate = new EndOperationDelegate(this.OnEndGetMarketPrices);
            }
            if ((this.onGetMarketPricesCompletedDelegate == null)) {
                this.onGetMarketPricesCompletedDelegate = new System.Threading.SendOrPostCallback(this.OnGetMarketPricesCompleted);
            }
            base.InvokeAsync(this.onBeginGetMarketPricesDelegate, null, this.onEndGetMarketPricesDelegate, this.onGetMarketPricesCompletedDelegate, userState);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        System.IAsyncResult Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService.BeginGetMarketPrice(Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceRequest request, System.AsyncCallback callback, object asyncState) {
            return base.Channel.BeginGetMarketPrice(request, callback, asyncState);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        private System.IAsyncResult BeginGetMarketPrice(string Symbol, System.AsyncCallback callback, object asyncState) {
            Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceRequest inValue = new Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceRequest();
            inValue.Symbol = Symbol;
            return ((Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService)(this)).BeginGetMarketPrice(inValue, callback, asyncState);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceResponse Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService.EndGetMarketPrice(System.IAsyncResult result) {
            return base.Channel.EndGetMarketPrice(result);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        private Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketPrice EndGetMarketPrice(System.IAsyncResult result) {
            Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceResponse retVal = ((Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService)(this)).EndGetMarketPrice(result);
            return retVal.MarketPrice;
        }
        
        private System.IAsyncResult OnBeginGetMarketPrice(object[] inValues, System.AsyncCallback callback, object asyncState) {
            string Symbol = ((string)(inValues[0]));
            return this.BeginGetMarketPrice(Symbol, callback, asyncState);
        }
        
        private object[] OnEndGetMarketPrice(System.IAsyncResult result) {
            Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketPrice retVal = this.EndGetMarketPrice(result);
            return new object[] {
                    retVal};
        }
        
        private void OnGetMarketPriceCompleted(object state) {
            if ((this.GetMarketPriceCompleted != null)) {
                InvokeAsyncCompletedEventArgs e = ((InvokeAsyncCompletedEventArgs)(state));
                this.GetMarketPriceCompleted(this, new GetMarketPriceCompletedEventArgs(e.Results, e.Error, e.Cancelled, e.UserState));
            }
        }
        
        public void GetMarketPriceAsync(string Symbol) {
            this.GetMarketPriceAsync(Symbol, null);
        }
        
        public void GetMarketPriceAsync(string Symbol, object userState) {
            if ((this.onBeginGetMarketPriceDelegate == null)) {
                this.onBeginGetMarketPriceDelegate = new BeginOperationDelegate(this.OnBeginGetMarketPrice);
            }
            if ((this.onEndGetMarketPriceDelegate == null)) {
                this.onEndGetMarketPriceDelegate = new EndOperationDelegate(this.OnEndGetMarketPrice);
            }
            if ((this.onGetMarketPriceCompletedDelegate == null)) {
                this.onGetMarketPriceCompletedDelegate = new System.Threading.SendOrPostCallback(this.OnGetMarketPriceCompleted);
            }
            base.InvokeAsync(this.onBeginGetMarketPriceDelegate, new object[] {
                        Symbol}, this.onEndGetMarketPriceDelegate, this.onGetMarketPriceCompletedDelegate, userState);
        }
        
        private System.IAsyncResult OnBeginOpen(object[] inValues, System.AsyncCallback callback, object asyncState) {
            return ((System.ServiceModel.ICommunicationObject)(this)).BeginOpen(callback, asyncState);
        }
        
        private object[] OnEndOpen(System.IAsyncResult result) {
            ((System.ServiceModel.ICommunicationObject)(this)).EndOpen(result);
            return null;
        }
        
        private void OnOpenCompleted(object state) {
            if ((this.OpenCompleted != null)) {
                InvokeAsyncCompletedEventArgs e = ((InvokeAsyncCompletedEventArgs)(state));
                this.OpenCompleted(this, new System.ComponentModel.AsyncCompletedEventArgs(e.Error, e.Cancelled, e.UserState));
            }
        }
        
        public void OpenAsync() {
            this.OpenAsync(null);
        }
        
        public void OpenAsync(object userState) {
            if ((this.onBeginOpenDelegate == null)) {
                this.onBeginOpenDelegate = new BeginOperationDelegate(this.OnBeginOpen);
            }
            if ((this.onEndOpenDelegate == null)) {
                this.onEndOpenDelegate = new EndOperationDelegate(this.OnEndOpen);
            }
            if ((this.onOpenCompletedDelegate == null)) {
                this.onOpenCompletedDelegate = new System.Threading.SendOrPostCallback(this.OnOpenCompleted);
            }
            base.InvokeAsync(this.onBeginOpenDelegate, null, this.onEndOpenDelegate, this.onOpenCompletedDelegate, userState);
        }
        
        private System.IAsyncResult OnBeginClose(object[] inValues, System.AsyncCallback callback, object asyncState) {
            return ((System.ServiceModel.ICommunicationObject)(this)).BeginClose(callback, asyncState);
        }
        
        private object[] OnEndClose(System.IAsyncResult result) {
            ((System.ServiceModel.ICommunicationObject)(this)).EndClose(result);
            return null;
        }
        
        private void OnCloseCompleted(object state) {
            if ((this.CloseCompleted != null)) {
                InvokeAsyncCompletedEventArgs e = ((InvokeAsyncCompletedEventArgs)(state));
                this.CloseCompleted(this, new System.ComponentModel.AsyncCompletedEventArgs(e.Error, e.Cancelled, e.UserState));
            }
        }
        
        public void CloseAsync() {
            this.CloseAsync(null);
        }
        
        public void CloseAsync(object userState) {
            if ((this.onBeginCloseDelegate == null)) {
                this.onBeginCloseDelegate = new BeginOperationDelegate(this.OnBeginClose);
            }
            if ((this.onEndCloseDelegate == null)) {
                this.onEndCloseDelegate = new EndOperationDelegate(this.OnEndClose);
            }
            if ((this.onCloseCompletedDelegate == null)) {
                this.onCloseCompletedDelegate = new System.Threading.SendOrPostCallback(this.OnCloseCompleted);
            }
            base.InvokeAsync(this.onBeginCloseDelegate, null, this.onEndCloseDelegate, this.onCloseCompletedDelegate, userState);
        }
        
        protected override Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService CreateChannel() {
            return new MarketDataWebServiceClientChannel(this);
        }
        
        private class MarketDataWebServiceClientChannel : ChannelBase<Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService>, Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService {
            
            public MarketDataWebServiceClientChannel(System.ServiceModel.ClientBase<Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.MarketDataWebService> client) : 
                    base(client) {
            }
            
            public System.IAsyncResult BeginGetMarketPrices(Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPricesRequest request, System.AsyncCallback callback, object asyncState) {
                object[] _args = new object[1];
                _args[0] = request;
                System.IAsyncResult _result = base.BeginInvoke("GetMarketPrices", _args, callback, asyncState);
                return _result;
            }
            
            public Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPricesResponse EndGetMarketPrices(System.IAsyncResult result) {
                object[] _args = new object[0];
                Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPricesResponse _result = ((Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPricesResponse)(base.EndInvoke("GetMarketPrices", _args, result)));
                return _result;
            }
            
            public System.IAsyncResult BeginGetMarketPrice(Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceRequest request, System.AsyncCallback callback, object asyncState) {
                object[] _args = new object[1];
                _args[0] = request;
                System.IAsyncResult _result = base.BeginInvoke("GetMarketPrice", _args, callback, asyncState);
                return _result;
            }
            
            public Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceResponse EndGetMarketPrice(System.IAsyncResult result) {
                object[] _args = new object[0];
                Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceResponse _result = ((Bullsfirst.InterfaceOut.Oms.MarketDataServiceReference.GetMarketPriceResponse)(base.EndInvoke("GetMarketPrice", _args, result)));
                return _result;
            }
        }
    }

    public interface IMarketDataServiceAsync : MarketDataWebService
    {
        void GetMarketPricesAsync();
        void GetMarketPriceAsync(string Symbol);

        event EventHandler<GetMarketPricesCompletedEventArgs> GetMarketPricesCompleted;
        event EventHandler<GetMarketPriceCompletedEventArgs> GetMarketPriceCompleted;
    }

    [Export(typeof(IMarketDataServiceAsync))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public partial class MarketDataWebServiceClient : IMarketDataServiceAsync
    {
    }
}