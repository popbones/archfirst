(function($) {

    var isStarted = false;
    var updateTimer;

    $(function () {
        var gridCB = new AF.Grid({
            dataSource: new AF.Grid.FakeLocalSource(AF.Grid.fakeData.liveDataSample),
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

        $.cookie("data", null);

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
            data.id = 1+Math.floor(Math.random()*50);
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
            $.cookie("data",JSON.stringify(data));
        }
        updateRow(data);
        updateTimer = window.setTimeout(updateRowData, 100);
    }

}(jQuery));