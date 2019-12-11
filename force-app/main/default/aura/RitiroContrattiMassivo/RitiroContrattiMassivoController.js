({
    init:function(cmp,event){
        cmp.set('v.showTable',false);
        var action=cmp.get('c.getContracts');
        action.setCallback
        (
        	this,
            function(response){
                if(response.getState()=='SUCCESS'){
                    var res=response.getReturnValue();
                    cmp.set('v.contracts',res);
                }
            }
        );
        $A.enqueueAction(action);
    },
    
    barcodeEvent:function(cmp, event) {
		var checkContract=cmp.get('c.checkContract');
        var barcode=event.getParam('barCode');
        checkContract.setParam('barcode',barcode);
        checkContract.setParam('contracts',cmp.get('v.contracts'));
        checkContract.setCallback
        (
            this,
            function(response1){
                if(response1.getState()=='SUCCESS'){
                    var ctrResult = response1.getReturnValue();
                    if(ctrResult!=null){
                        cmp.set('v.notFound',false);
                        var ctrResList=cmp.get('v.ctrResults');
                        var isIn=false;
                        if(ctrResList==undefined){
                            ctrResList=[];
                        }
                        else{
                            for(var i=0;i<ctrResList.length;i++){
                                if(ctrResList[i]['contract']['Barcode__c']==barcode){
                                    isIn=true;
                                    break;
                                }
                            }
                        }
                        if(!isIn){
                            ctrResList.push(ctrResult);
                        }
                        cmp.set('v.ctrResults',ctrResList);
                    }
                    else{
                        cmp.set('v.notFound',true);
                    }
                    var ctrResList=cmp.get('v.ctrResults');
                    cmp.set('v.showTable',(ctrResList.length!=0));
                }
            }
        );
        $A.enqueueAction(checkContract);
        cmp.set('v.textValue','');
	}
})