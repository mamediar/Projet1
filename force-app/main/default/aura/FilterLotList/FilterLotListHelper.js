({
	helperInit : function(cmp,event,helper) {
		var status=cmp.get('v.status');
        var hasFilter=cmp.get('v.filter');
        
        if(!hasFilter){
            if(status=='3'){
                cmp.set('v.columns',[
                    {label:'Lotto',fieldName:'OCSLottoId__c',type:'text',initialWidth:100},
                    {label:'Bar Code',fieldName:'LotBarcode__c',type:'text'}
                ]);
                cmp.set('v.title','da ricevere:');
            }
            else{
                cmp.set('v.columns',[
                    {label:'Lotto',fieldName:'OCSLottoId__c',type:'text',initialWidth:100},
                    {label:'Bar Code',fieldName:'LotBarcode__c',type:'text'},
                    {label:'Data Ricezione IDM',fieldName:'DateReceivedIDM__c',type:'text'}
                ]);
                cmp.set('v.title','ricevuti:');
            }
            var action=cmp.get("c.getLotList");
            action.setParam('status',status);
            //action.setParam('fDate',date);
            action.setCallback
            (
                this,
                function(response){
                    if (response.getState() == 'SUCCESS'){
                        var result = response.getReturnValue();
                        if(result!=null && result!=undefined){
                            cmp.set('v.lotList',result);
                            var listData=[];
                            for(var i=0;i<result.length;i++){
                                if(result[i]['Status__c']==status){
                                    listData.push(result[i]);
                                }
                            }
                            cmp.set('v.lotListData',listData);
                            cmp.set('v.showList',listData.length!=0);
                        }
                    }
                }
            );
            $A.enqueueAction(action);
        }
        else{
            cmp.set('v.columns',[
                    {label:'Lotto',fieldName:'OCSLottoId__c',type:'text',initialWidth:100},
                    {label:'Bar Code',fieldName:'LotBarcode__c',type:'text'},
                    {label:'Data Ricezione IDM',fieldName:'DateReceivedIDM__c',type:'text'}
                ]);
            
            if(cmp.get('v.title')==null || cmp.get('v.title')==undefined){
            	cmp.set('v.title','ricevuti oggi:');
            }
            
            var filterValue=(cmp.get('v.filterValue')==null || cmp.get('v.filterValue')==undefined)?
                'TODAY':
            	cmp.get('v.filterValue');
            var getLots=cmp.get('c.getFilteredLotList');
            getLots.setParam('status','4');
            getLots.setParam('filter',filterValue);
            getLots.setCallback
            (
                this,
                function(response){
                    if(response.getState()=='SUCCESS'){
                        var result = response.getReturnValue();
                        if(result!=null && result!=undefined){
                            cmp.set('v.lotList',result);
                            var listData=[];
                            for(var i=0;i<result.length;i++){
                                if(result[i]['Status__c']==status){
                                    listData.push(result[i]);
                                }
                            }
                            cmp.set('v.lotListData',listData);
                            cmp.set('v.showList',listData.length!=0);
                        }
                    }
                }
            );
            $A.enqueueAction(getLots);
        }
	}
})