({
nextPage : function(component, event){

        var accountList = component.get("v.objectList");
        var end = parseInt(component.get("v.end"));
        var start = parseInt(component.get("v.start"));
        var pageSize = parseInt(component.get("v.pageSize"));
        var currentPage=parseInt(component.get("v.currentPage"));

		var paginationList = component.get("v.paginationList");
		var pageBegin= end+1;
        var pageEnd=pageBegin+pageSize;

        console.log("paginationList: "+paginationList.length);
        console.log("pageBegin: "+pageBegin);
        console.log("accountList.length : "+accountList.length);
        console.log("pageEnd: "+pageEnd);

        var counter = 0;
 		var paginationList = [];
        for(var i=pageBegin; i<pageEnd; i++){
            if( i < accountList.length )
            {
				paginationList.push(accountList[i]);
                counter++;
                console.log(i+") " + accountList[i].Name);
            }
        }

        start = start + counter;
        end = end + counter;

        console.log("start: "+start);
        console.log("end: "+end);

        component.set("v.start",start);
        component.set("v.end",end);

        currentPage=currentPage+1;
        component.set("v.currentPage", currentPage);
        component.set('v.paginationList', paginationList);
    },
 previousPage : function(component, event) {

        var accountList = component.get("v.objectList");
        var currentList=component.get("v.paginationList");
        var end = parseInt(component.get("v.end"));
        var start = parseInt(component.get("v.start"));
        var pageSize = parseInt(component.get("v.pageSize"));
        var currentPage=parseInt(component.get("v.currentPage"));

        var e = end-currentList.length;
        var s = e-pageSize+1;

        if(s < 0)
        {
            s = 0;
            e = pageSize-1;
        }
        var paginationList = [];

        for(var i=s; i<e+1; i++){
            paginationList.push(accountList[i]);
        }
        currentPage=currentPage-1;
        component.set("v.currentPage", currentPage);

        component.set("v.start",s);
        component.set("v.end",e);
        component.set('v.paginationList', paginationList);

    },

    firstPage: function(component, event) {

        var accountList = component.get("v.objectList");
        var pageSize = component.get("v.pageSize");

        var paginationList = [];
        for(var i=0; i< pageSize; i++)
        {
            paginationList.push(accountList[i]);
        }

        component.set("v.currentPage", 1);
        component.set("v.start",0);
        component.set("v.end",pageSize-1);
        component.set('v.paginationList', paginationList);
    },
     lastPage: function(component, event) {
            var accountList = component.get("v.objectList");
            var totalRecord = parseInt(component.get("v.totalRecord"));
            var pageSize = parseInt(component.get("v.pageSize"));

            var page=Math.ceil(totalRecord/pageSize);
            var paginationList = [];
            console.log("pages "+page+" pageSize "+pageSize);

                for(var i=(page-1)*pageSize; i< totalRecord; i++)
                {
                    paginationList.push(accountList[i]);
                }

            component.set("v.currentPage", component.get("v.totalPage"));
            component.set("v.start",(page-1)*pageSize);
            component.set("v.end",totalRecord-1);
            component.set('v.paginationList', paginationList);
        },
            toPage: function(component, event) {
                var accountList = component.get("v.objectList");
                var pageSize = parseInt(component.get("v.pageSize"));

                var currentPage= parseInt(component.get("v.currentPage"));

                console.log("currentPage: "+currentPage);

                var start=pageSize*(currentPage-1);
                if(start<0)
                    start=1;

                var end=start+pageSize-1;
                if(end>accountList.length)
                    end=accountList.length;

                console.log("start: "+start);
                console.log("end: "+end);

                var paginationList = [];
                for(var i=start; i<= end; i++)
                {
                    if(i<accountList.length)
                    	paginationList.push(accountList[i]);
                }

                component.set("v.start",start);
                component.set("v.end",end);

                component.set('v.paginationList', paginationList);
            },
})