({
	init : function(cmp, event, helper) {
        
       
        var action=cmp.get("c.returnSfalottiRelatedToCase");
        action.setCallback
        (
            this,
            function(response){
                if (response.getState() == 'SUCCESS'){                    
                	var result = response.getReturnValue();
                    if(result!=null && result!=undefined){
                        cmp.set('v.lotList',result);
                        cmp.set('v.countLotti',result.length);
                    }
                }
            }
        );
        $A.enqueueAction(action);
    },
    checkIsIn:function(cmp,event,helper){
        var navigate = cmp.get('v.navigateFlow');
        var tempInput=event.getParam('barCode');
        var list = (cmp.get("v.lotList") != null) ? cmp.get("v.lotList") : [];
        var isIn=false;
        for(var i=0;i<list.length && !isIn;i++)
        {
        	
            if(list[i]['LotBarcode__c']==tempInput)
            {
               isIn=true;
               cmp.set('v.lotto',list[i]);
            	console.log(list[i]);
            }
        }
       	if(isIn)
        {
            console.log(cmp.get('v.contratti'));
           	navigate("NEXT");
        }
        else
        {
            cmp.set('v.checkFind',true);
        }    
    }
})