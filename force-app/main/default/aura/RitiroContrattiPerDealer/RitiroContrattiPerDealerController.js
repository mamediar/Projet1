({
    init:function(cmp, event,helper) {
        helper.helperInit(cmp,event,helper);
    },
    
    onListChange:function(cmp,event){
        var size=event.getParam('value').length;
        cmp.set('v.isButtonDisabled',size==0);
    },
    
    handleClick:function(cmp,event,helper){
        var list=cmp.get('v.selectedRows');
        var cListIds = [];
        for (var i=0; i<list.length; i++) {
            cListIds[i] = list[i];
        }
        var evt = $A.get("e.c:OpenModalEvent");
        var action=cmp.get('c.cambioStatoDocumenti');
        action.setParam('cListIds',cListIds);
        action.setCallback
        (
            this,
            function(response,helper){
                if(response.getState()=='SUCCESS'){
                    var OCSResponseList=response.getReturnValue();
                    var listLen=list.length;
                    var isListOk=true;
                    cmp.set('v.resList',OCSResponseList);
                    
                    for(var i=0;i<OCSResponseList.length;i++){
                        if(OCSResponseList[i]['koDocuments'].length>0){
                            isListOk=false;
                            break;
                        }
                    }
                    
                    if(isListOk){
                        cmp.set('v.variant','success');
                        evt.setParams({
                            "openModal": true,
                            "title":"Operazione Completata"});
                        evt.fire();
                    setTimeout(function(){ $A.get('e.force:refreshView').fire(); }, 200);
                    }
                    else{
                        cmp.set('v.variant','error');
                        evt.setParams({
                            "openModal": true,
                            "title":"Operazione Non Completata"
                        });
                        evt.fire();
                    }
                    
                    
                }
                
            }
            
        );
        $A.enqueueAction(action);
    },
    
    checkIsIn: function (cmp, event, helper) {
        var barcode=event.getParam('barCode');
        var selectedRows = cmp.get("v.selectedRows") ? cmp.get("v.selectedRows") : [];
        var contractList = cmp.get("v.contractList");
        var trovato=false;
        for (var i=0; i<contractList.length; i++) {
            if (contractList[i].Barcode__c == barcode) {
                selectedRows.push(contractList[i].Id);
                trovato=true;
            }
        }
        cmp.set('v.barcodeValue','');
        cmp.set('v.showNotFoundMessage',!trovato);
        cmp.set("v.selectedRows", selectedRows);
    },
    
    closeCallback:function(cmp,event,helper){
        var evt=cmp.getEvent('reInit');
        var evt2 = $A.get("e.c:OpenModalEvent");
        evt2.setParams({
            "openModal": false
        });
        var notes=cmp.get('v.note');
        if(notes){
            var action=cmp.get('c.writeNotes');
            action.setParams({
                'caseId':cmp.get('v.recordId'),
                'notes':notes
            });
            action.setCallback(this,function(resp){
                if(resp.getState()=='SUCCESS'){
                    evt.fire();
                    evt2.fire();
                }
            });
            $A.enqueueAction(action);
        }
        else{
            evt.fire();
            evt2.fire();  
        }
    }
})