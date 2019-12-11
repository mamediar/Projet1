({
    init : function(cmp, event, helper) {
        cmp.set('v.title','Confirm Lot Receipt');
        cmp.set('v.filter','TODAY');
        
        var date=new Date();
        var d=date.getDate();
        var m=date.getMonth()+1;
        var y=date.getFullYear();
        var today=y+'-'+m+'-'+d;
        cmp.set('v.today',today);
        cmp.set('v.today2',today);
        
        var setLots=cmp.get('c.setLotData');
        setLots.setCallback
        (
            this,
            function(response2){
                if(response2.getState()=='SUCCESS'){
                    var lotList=response2.getReturnValue();
                    cmp.set('v.lotList',lotList);
                }
            }
        );
        $A.enqueueAction(setLots);
        var action=cmp.get('c.generateURL');
        action.setParam('filter','TODAY');
        action.setCallback
        (
            this,
            function(response){
                if(response.getState()=='SUCCESS'){
                    cmp.set('v.excelURL',response.getReturnValue());
                    cmp.set('v.isExcelDisabled',false);
                }
            }
        );
        $A.enqueueAction(action);
    },
    
    barcodeAction:function(cmp,event){
        var barcode=event.getParam('barCode');
        var list = (cmp.get('v.lotList') != null) ? cmp.get('v.lotList') : [];
        console.log('Barcode; list:');
        console.log(list);
        var i=0;
        var lot=null;
        var isOk=true;
        for(i=0;i<list.length;i++){
            if(list[i]['LotBarcode__c']==barcode){
                if(list[i]['Status__c']=='3'){
                    lot=list[i];
                    break;
                }
                else{
                    isOk=false;
                    break;
                }
            }
        }
        if(lot==null){
            cmp.set('v.errorFlag',true);
        }
        else{
            cmp.set('v.errorFlag',false);
            if(isOk){
                var update=cmp.get('c.receiveLot');
                update.setParam('lot',lot);
                update.setCallback
                (
                    this,
                    function(response){
                        if(response.getState()=='SUCCESS'){
                            list.splice(i,1);
                            cmp.set('v.lotList',list);
                            if(list.length==0){
                                var close=cmp.get('c.closeCase');
                                close.setCallback
                                (
                                    this,
                                    function(response){
                                        //Toast 'Caso chiuso?'
                                    }
                                );
                                $A.enqueueAction(close);
                            }
                        }
                        $A.get('e.force:refreshView').fire();
                    }
                );
                $A.enqueueAction(update);
            }
        }
        cmp.set('v.textValue','');
    },
    
    showRange:function(cmp,event){
        cmp.set('v.showRange',true);
    },
    
    handleChange:function(cmp,event){
        var value=event.getSource().get('v.value');
        var isOk=true;
        cmp.set('v.isExcelDisabled',true);
        var filter;
        if(value=='TODAY'){
            cmp.set('v.disableInput',true);
            cmp.set('v.required',false);
            filter='TODAY';
        }
        else{
            if(value==undefined || value==null){
                value='range'
            }
            if(value=='range' || value.includes('-')){
                cmp.set('v.disableInput',false);
                cmp.set('v.required',true);
            }
            else{
                cmp.set('v.disableInput',true);
                cmp.set('v.required',false);
                var date=new Date();
                var d=date.getDate();
                var m=date.getMonth()+1;
                var y=date.getFullYear();
                var today=y+'-'+m+'-'+d;
                cmp.set('v.today',today);
                cmp.set('v.today2',today);
            }
            var dal=cmp.find('dal').get('v.value');
            var al=cmp.find('al').get('v.value');
            if(dal==''||al==''||dal>al||al<dal||dal==null||al==null||dal==undefined||al==undefined){
                isOk=false;
            }
            
            filter=
                (
                value=='LAST_N_DAYS:7'||value=='LAST_N_DAYS:30'?
                value:
                cmp.find('dal').get('v.value')+','+cmp.find('al').get('v.value')
            );
        }
        cmp.set('v.filter',filter);
        
        var action=cmp.get('c.generateURL');
        action.setParam('filter',filter);
        action.setCallback
        (
            this,
            function(response){
                if(response.getState()=='SUCCESS'){
                    cmp.set('v.excelURL',response.getReturnValue());
                    cmp.set('v.isExcelDisabled',!isOk);
                }
            }
        );
        $A.enqueueAction(action);
    }
})