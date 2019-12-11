({
	init : function(cmp, event, helper) {
        cmp.set('v.columns',[
            {label:'Lotto',fieldName:'OCSLottoId__c',type:'text',initialWidth:100},
            {label:'Bar Code',fieldName:'LotBarcode__c',type:'text'}
        ]);
        
        var action=cmp.get("c.setTableLotData");
        action.setParam('caseId',cmp.get('v.recordId'));
        action.setCallback
        (
            this,
            function(response){
                if (response.getState() == 'SUCCESS'){                    
                	var result = response.getReturnValue();
                    if(result!=null && result!=undefined){
                        cmp.set('v.lotList',result);
                        cmp.set('v.showList',result.length!=0);
                        cmp.set('v.loaded',true);
                        $A.get('e.force:refreshView').fire();
                    }
                    cmp.set('v.loaded',true);
                }
            }
        );
        $A.enqueueAction(action);
	},
    
    checkIsIn:function(cmp,event,helper){
        var tempInput=event.getParam('barCode');
        var list = (cmp.get('v.lotList') != null) ? cmp.get('v.lotList') : [];
        var selectedIds = cmp.get('v.selectedIds');
        var selectedRows=cmp.get('v.selectedRows');
        var isIn=false;
        for(var i=0;i<list.length;i++){
            if(list[i]['LotBarcode__c']==tempInput){
                isIn=true;
                var trovato=false;
                for(var j=0;j<selectedRows.length;j++){
                    if(selectedRows[j]['LotBarcode__c']==list[i]['LotBarcode__c']){
                        trovato=true;
                        break;
                    }
                }
                if(!trovato){
                    selectedRows.push(list[i]);
                    selectedIds.push(list[i]['Id']);
                }
				cmp.set('v.selectedRows',selectedRows);
                cmp.set("v.selectedIds",selectedIds);
                break;
            }
        }
        cmp.set('v.isButtonDisabled',selectedRows.length==0);
        cmp.set('v.closeCase',selectedRows.length==list.length);
        cmp.set('v.errorFlag',!isIn);
        cmp.set('v.textValue','');
    },
    
    updateSelectedRows : function(cmp, event, helper) {
        var selectedRows = event.getParam('selectedRows'); 
        var list = (cmp.get('v.lotList') != null) ? cmp.get('v.lotList') : [];
       	var temp=[];
        var temp2=[];
        for(var i=0;i<selectedRows.length;i++){
            temp.push(selectedRows[i]['Id']);
            temp2.push(selectedRows[i]);
        }
        cmp.set('v.selectedRows',temp2);
        cmp.set("v.selectedIds",temp);
        cmp.set('v.isButtonDisabled',selectedRows.length==0);
        cmp.set('v.closeCase',selectedRows.length==list.length);
        cmp.set('v.errorFlag',false);
    },
    
    navigateFlow:function(cmp,event){
        var nav=cmp.get('v.navigateFlow');
        nav('NEXT');
    }
    
})