 (function ($) {

    AF.Grid.fakeDataCB = (function () {
        function getColumns() {
            return [{
                label:"Status",
                id:"colStatus",
                width: 100,
                filterData:"",
                groupBy: true
            }, {
                label:"CCP",
                id:"colCCP",
                width: 80,
                filterData: AF.Grid.FakeLocalStore.getFilterData(1, rows),
                groupBy: true           
            }, {
                label:"Product Type",
                id:"colProdType",
                width: 80,
                filterData: AF.Grid.FakeLocalStore.getFilterData(2, rows),
                groupBy: true
            }, {
                label:"Trade ID",
                id:"colTradeId",
                width: 100,
                filterData:"",
                groupBy: true
            }, {
                label:"Trade Date",
                id:"colTradeDate",
                renderer:"DATE",
                width: 100,
                filterData:"DATERANGE",
                groupBy: true
            }, {
                label:"Maturity Date",
                id:"colMaturityDate",
                renderer:"DATE",
                width: 100,
                filterData:"DATERANGE",
                groupBy: true
            }, {
                label:"Notional",
                id:"colNotional",
                width: 100,
                filterData:"",
                groupBy: true,
                renderer: "NUMBER"
            }, {
                label:"MTM",
                id:"colMTM",
                width: 100,
                filterData:"",
                groupBy: true,
                renderer: "NUMBER"
            }, {
                label:"Currency",
                id:"colCurrency",
                width: 100,
                filterData: AF.Grid.FakeLocalStore.getFilterData(8, rows),
                groupBy: true
            }, {
                label:"Buy/Sell",
                id:"colBuySell",
                width: 100,
                filterData: AF.Grid.FakeLocalStore.getFilterData(9, rows),
                groupBy: true
            }, {
                label:"Rate",
                id:"colRate",
                width: 80,
                filterData:"",
                groupBy: true
            }];
        }
                
        var rows = [
                    { id: 1, data: ["Cleared","LCH","IRS",72353245,"10/10/2012","10/10/2013","10,250,000","2,000,000.00","EUR","Buy","1%"] },   
                    { id: 2, data: ["Cleared","LCH","IRS",6576,"10/10/2012","10/10/2013","1,250,000","7,265,523.00","EUR","Buy","1%"] },
                    { id: 3, data: ["Cleared","LCH","IRS",453215,"10/10/2012","10/10/2013","5,000,000","1,245,000.00","EUR","Buy","1%"] },
                    { id: 4, data: ["Cleared","LCH","IRS",4587,"05/10/2012","05/10/2013","75,000,000","1,347,800.00","EUR","Buy","1%"] },
                    { id: 5, data: ["Cleared","LCH","IRS",987988,"05/10/2012","05/10/2013","12,300,000","-150,000,000.00","USD","Buy","1%"] },
                    { id: 6, data: ["Cleared","LCH","IRS",432,"05/10/2012","05/10/2013","15,000,000","130,000,000.00","USD","Buy","1%"] },
                    { id: 7, data: ["Cleared","LCH","IRS",532545876,"04/10/2012","04/10/2013","10,000,000","-232,323,323.00","USD","Buy","1%"] },
                    { id: 8, data: ["Cleared","LCH","IRS",65865,"04/10/2012","04/10/2013","7,500,000","2,000,000.00","GBP","Buy","1%"] },
                    { id: 9, data: ["Cleared","LCH","IRS",659,"04/10/2012","04/10/2013","2,500,000","-1,222,200.00","GBP","Buy","1%"] },
                    { id: 10, data: ["Cleared","LCH","IRS",7657345736,"05/10/2012","10/10/2013","45,000,000","-239,687,200.00","EUR","Buy","1%"] },
                    { id: 11, data: ["Cleared","LCH","IRS",376367,"06/10/2012","10/10/2013","23,000,000","234,243,543.00","EUR","Buy","1%"] },
                    { id: 12, data: ["Cleared","LCH","IRS",453215,"07/10/2012","10/10/2013","430,000,000","6,456.00","EUR","Buy","1%"] },
                    { id: 13, data: ["Cleared","LCH","IRS",65875700000,"10/10/2011","05/10/2013","5,600,000","456,436.00","EUR","Buy","1%"] },
                    { id: 14, data: ["Cleared","LCH","IRS",568758,"10/10/2011","05/10/2013","5,344,300","65,760.00","USD","Buy","1%"] },
                    { id: 15, data: ["Cleared","LCH","IRS",5568657,"10/10/2011","05/10/2013","3,434,300","8,000,000.00","USD","Buy","1%"] },
                    { id: 16, data: ["Cleared","LCH","IRS",5767685,"05/10/2011","04/10/2013","23,432,000","65,765,000.00","USD","Buy","2%"]},
                    { id: 17, data: ["Cleared","LCH","IRS",7698797,"05/10/2011","04/10/2013","32,432,430","7,878,777.00","GBP","Buy","2%"] },
                    { id: 18, data: ["Cleared","LCH","IRS",76365,"05/10/2011","04/10/2013","34,543,500","-147,000,000.00","GBP","Buy","2%"] },
                    { id: 19, data: ["Cleared","LCH","IRS",3346456436,"04/10/2011","10/10/2014","34,000,034","-23,424,354.00","EUR","Buy","2%"] },
                    { id: 20, data: ["Cleared","LCH","IRS",6797698769,"04/10/2011","10/10/2014","10,250,000","-6,456.00","EUR","Buy","2%"] },
                    { id: 21, data: ["Cleared","LCH","IRS",98785675,"04/10/2011","10/10/2014","1,250,000","-456,436.00","EUR","Buy","2%"] },
                    { id: 22, data: ["Cleared","LCH","IRS",65789789,"05/10/2011","05/10/2014","5,000,000","-65,760,000.00","EUR","Buy","2%"] },
                    { id: 23, data: ["Cleared","LCH","IRS",6877980,"06/10/2011","05/10/2014","75,000,000","-8,000,000.00","USD","Buy","2%"] },
                    { id: 24, data: ["Cleared","LCH","IRS",47889090,"07/10/2011","05/10/2015","12,300,000","-65,765,000.00","USD","Buy","2%"] },
                    { id: 25, data: ["Cleared","CME","IRS",76874,"10/10/2011","04/10/2015","10,000,000",-532.00 ,"GBP","Buy","2%"] },
                    { id: 26, data: ["Cleared","CME","IRS",47864,"05/10/2011","04/10/2015","7,500,000","-9,760,000.00","GBP","Sell","2%"] },
                    { id: 27, data: ["Cleared","CME","IRS",476474647,"05/10/2011","04/10/2013","2,500,000",-96.00 ,"EUR","Sell","3%"] },
                    { id: 28, data: ["Cleared","CME","IRS",4674768989,"05/10/2011","04/10/2013","45,000,000","-87,665.00","EUR","Sell","3%"] },
                    { id: 29, data: ["Cleared","CME","IRS",4876457,"04/10/2011","10/10/2013","23,000,000", 876.00 ,"EUR","Sell","3%"] },
                    { id: 30, data: ["Cleared","CME","IRS",488965,"04/10/2011","10/10/2013","430,000,000","70,000,000.00","EUR","Sell","3%"] },
                    { id: 31, data: ["Cleared","CME","IRS",356836,"04/10/2011","10/10/2013","5,600,000","85,687.00","USD","Sell","3%"] },
                    { id: 32, data: ["Cleared","CME","IRS",3639477,"10/10/2011","05/10/2013","5,344,300","437,689.00","USD","Sell","3%"] },
                    { id: 33, data: ["Cleared","CME","IRS",532545876,"10/10/2011","05/10/2013","3,434,300","59,700.00","USD","Sell","3%"] },
                    { id: 34, data: ["Cleared","CME","IRS",65865,"05/10/2011","05/10/2013","23,432,000","650,000.00","GBP","Sell","3%"] },
                    { id: 35, data: ["Cleared","CME","IRS",383853,"05/10/2011","04/10/2013","32,432,430","74,265.00","GBP","Sell","3%"] },
                    { id: 36, data: ["Cleared","CME","IRS",72353245,"05/10/2011","04/10/2013","34,543,500","67,457.00","EUR","Sell","3%"] },
                    { id: 37, data: ["Cleared","CME","IRS",368386,"04/10/2011","04/10/2013","34,000,034","7,347.00","EUR","Sell","3%"] },
                    { id: 38, data: ["Cleared","CME","IRS",453215,"04/10/2011","10/10/2014","10,250,000","95,000,000.00","EUR","Sell","0%"] },
                    { id: 39, data: ["Cleared","CME","IRS",4587,"04/10/2011","10/10/2014","1,250,000","53,675.00","EUR","Sell","3%"] },
                    { id: 40, data: ["Cleared","CME","IRS",987988,"10/10/2011","10/10/2014","5,000,000","7,387.00","USD","Sell","3%"] },
                    { id: 41, data: ["Cleared","CME","IRS",432,"10/10/2011","05/10/2014","75,000,000","24,537,990.00","USD","Sell","3%"] },
                    { id: 42, data: ["Cleared","CME","IRS",532545876,"05/10/2011","05/10/2014","12,300,000","757,653.00","USD","Sell","3%"] },
                    { id: 43, data: ["Cleared","CME","IRS",65865,"05/10/2011","05/10/2015","15,000,000","643,563.00","GBP","Sell","3%"] },
                    { id: 44, data: ["Cleared","CME","IRS",659,"05/10/2011","04/10/2015","10,000,000","4,532.00","GBP","Sell","3%"]}];
        
        return {
            columns: getColumns(),
            rows: rows
        };

    }());

}(jQuery));