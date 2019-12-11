({
	helperInit : function(cmp,event,helper) {
        cmp.set('v.selectedRows',[]);
		var closed=false;
        
        var checkStatus=cmp.get('c.checkIfClosed');
        checkStatus.setParam('caseId',cmp.get('v.recordId'));
        checkStatus.setCallback
        (
            this,
            function(response,helper){
                if(response.getState()=='SUCCESS'){
                    closed=response.getReturnValue();
                    $A.enqueueAction(nContracts);
                }            
            }
        );
        $A.enqueueAction(checkStatus);
        
        var nContracts=cmp.get('c.getInfo');
        nContracts.setParam('caseId',cmp.get('v.recordId'));
        nContracts.setCallback
        (
            this,
            function(response1,helper){
                if(response1.getState()=='SUCCESS'){
                    var res1=response1.getReturnValue();
                    var n=parseInt(res1['n']);
                    var p=parseInt(res1['p']);
                    cmp.set('v.dealer',res1['dealer']);
                    cmp.set('v.nContracts',n);
                    cmp.set('v.pContracts',p);
                    cmp.set('v.note',res1['notes']);
                    if(!closed && n==p){
                        var closeCase=cmp.get('c.closeCase');
                        closeCase.setParam('caseId',cmp.get('v.recordId'));
                        closeCase.setCallback
                        (
                            this,
                            function(response2,helper){
                                if(response2.getState()=='SUCCESS'){
                                    if(response2.getReturnValue()){
                                        cmp.find('notifLib').showToast({                                               
                                            "variant":"Success",                        
                                            "title": "Il Caso è stato chiuso"
                                        });
                                        this.helperInit(cmp,event,helper);
                                        $A.get('e.force:refreshView').fire();
                                    }
                                }
                            }
                        );
                        $A.enqueueAction(closeCase);
                    }
                }
            }
        );
	}
})