({
	init : function(cmp, event, helper) 
    {     
    var booleanFineFlow = cmp.get('v.booleanFineFlow');
    var toastEvent = $A.get("e.force:showToast");
    var navigate = cmp.get('v.navigateFlow');
        if(cmp.get('v.type') != null && cmp.get('v.type') != undefined && cmp.get('v.type') != '' ){
        toastEvent.setParams({
       		title : cmp.get('v.title'),
       		type : cmp.get('v.type'),
       		message : cmp.get('v.messagge'),
    	});            
        toastEvent.fire();
        }
        if(booleanFineFlow){
        	setTimeout(function(){navigate("FINISH"); }, 10);    
        }
        else{
        	setTimeout(function(){navigate("NEXT"); }, 10);    
        }
    	console.log("DOPO IL FINISH");
      //  $A.get('e.force:refreshView').fire();
    }
})