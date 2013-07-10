var App = {};

(function($) {

    var isStarted = false;
    var updateTimer;

    $(function () {
        var webSocketService = new App.WebSocketService();

        webSocketService.connect();

        var gridCB = new AF.Grid({
            dataSource: new AF.Grid.FakeLocalSource(AF.Grid.fakeData.liveDataSample2),
            showToolbar: false,
            rowHover: false,
            id: "gridLive"
        });
        gridCB.load();

        //Set default theme for theme switcher
        setTimeout(function () {
            $("a.theme-sapient").click();
        }, 100);


        if (location.hash.indexOf("child")<0) {
            $(document).on("keydown", function(event) {
                if (event.keyCode === 83) {
                    isStarted = !isStarted;
                    isStarted ? updateRowData() : window.clearTimeout(updateTimer);
                }
            });
        } else {
            updateRowData();
        }

        $.cookie && $.cookie("data", null);

    });


    //Real time time data emulator
    function updateRow(data) {
        if (data) {
            $("#gridLive").trigger(jQuery.afGrid.updateRow, [data]);
        }
    }

    function updateRowData() {
        var data = JSON.parse($.cookie("data"));
        if (location.hash.indexOf("child")<0) {
            data = {};
            data.id = 1+Math.floor(Math.random()*9);
            randomData(data, "colBid");
            randomData(data, "colAsk");
            randomData(data, "colMin");
            data.colTime = new Date().toLocaleTimeString();
            function randomData(data, key) {
                if (Math.round(Math.random()*2)>1) {
                    data[key] = (1 + (Math.random() * 30));
                }
            }
            if (Math.round(Math.random()*2)>1) {
                data.colMax = (30 + (Math.random() * 30));
            }
//            if (Math.round(Math.random()*2)>1) {
//                data.colAskSize = Math.floor(Math.random() * 40000);
//            }
//            if (Math.round(Math.random()*2)>1) {
//                data.colBidSize = Math.floor(Math.random() * 40000);
//            }
            $.cookie && $.cookie("data",JSON.stringify(data));
        }
        updateRow(data);
        updateTimer = window.setTimeout(updateRowData, 100);
    }

}(jQuery));




(function() {
    App.WebSocketService = function() {

        var MY_WEBSOCKET_URL = "ws://tutorial.kaazing.com/jms";
        var TOPIC_NAME = "/topic/afGridTickUpdate";

        var MESSAGE_PROPERTIES = {
            "messageType": "MESSAGE_TYPE",
            "userId": "USER_ID",
            "tick": "TICK"
        };

        var MESSAGE_TYPES = {
            tickUpdate: "TICK_UPDATE"
        };

        var userId = Math.random(100000).toString();
        var connection;
        var session;
        var wsUrl;

        var sending = false;
        var sliderQueue = [];

        var WEBSOCKET_URL = MY_WEBSOCKET_URL;

        var handleException = function (e) {
            console.log("EXCEPTION: " + e);
        };

        var handleTopicMessage = function(message) {
            if (message.getStringProperty(MESSAGE_PROPERTIES.userId) != userId) {
                console.log("Message received: " + message.getText());
                $("#slider").val(message.getText());
                $("#pic").width(message.getText());
            }
        };

        var doSend = function(message) {
            message.setStringProperty(MESSAGE_PROPERTIES.userId, userId);
            topicProducer.send(null, message, DeliveryMode.NON_PERSISTENT, 3, 1, function() {
                sendFromQueue();
            });
            console.log("Message sent: " + message.getText());
        };

        var sliderChange = function(sliderValue) {
            console.log("Slider changed: " + sliderValue);
            $("#pic").width(sliderValue);
            if (!sending) {
                sending = true;
                doSend(session.createTextMessage(sliderValue));
            }
            else {
                sliderQueue.push(sliderValue);
                console.log("Busy sending, pushing to slider queue: " + sliderValue);
            }
        };
        var sendFromQueue = function() {
            if (sliderQueue.length > 0) {
                console.log("Sending last element from queue: " + sliderQueue[sliderQueue.length-1]);
                var msg = sliderQueue[sliderQueue.length-1];
                sliderQueue = [];
                doSend(session.createTextMessage(msg));
            }
            else {
                sending = false;
            }
        };

        var doConnect = function() {
            var stompConnectionFactory = new StompConnectionFactory(WEBSOCKET_URL);
            try {
                var connectionFuture = stompConnectionFactory.createConnection(function() {
                    if (!connectionFuture.exception) {
                        try {
                            connection = connectionFuture.getValue();
                            connection.setExceptionListener(handleException);
                            console.log("Connected to " + WEBSOCKET_URL);
                            session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
                            var myTopic = session.createTopic(TOPIC_NAME);
                            console.log("Topic created...");
                            topicProducer = session.createProducer(myTopic);
                            console.log("Topic producer created...");
                            topicConsumer = session.createConsumer(myTopic);
                            console.log("Topic consumer created...");
                            topicConsumer.setMessageListener(handleTopicMessage);
                            connection.start(function() {
                                console.log("JMS session created");
                                doSend(session.createTextMessage("Hello world..."));
                            });
                        } catch (e) {
                            handleException(e);
                        }
                    } else {
                        handleException(connectionFuture.exception);
                    }
                });
            } catch (e) {
                handleException(e);
            }
        };

        return {
            connect: doConnect
        };
    };

}());