({
    selectContracts : function(cmp) {
        var action = cmp.get('c.selectContract');
        action.setCallback(this, function(element){
            if(element.getState() == 'SUCCESS'){
                var result = element.getReturnValue();
                if(result.length < 1){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Nessuna pratica smarrita da visualizzare",
                        mode : "pester",
                        type : "info",
                        message: " "
                    });
                    toastEvent.fire();
                }
                cmp.set('v.contractList', result);
            }
        });
        $A.enqueueAction(action);
    },
    
    caseNewInstance : function(cmp, selectedRows){
        var action = cmp.get('c.caseGetInstance');
        console.log('riga 25');
        action.setParams({'contractList' : selectedRows});
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                var url = cmp.get('v.url');
                var elementDom = document.createElement('a');
                
                elementDom.setAttribute('target','_blank');
                elementDom.setAttribute('href', url + '&uniqCode=' + result );                
                //elementDom.setAttribute('download','');
                
                elementDom.style.display = 'none';
                document.body.appendChild(elementDom);
                elementDom.click();
                document.body.removeChild(elementDom);  
            }
        });
        $A.enqueueAction(action);
    },
    
    resetSelection : function(cmp){
        var c = cmp.find('contractTable');
        var arr = cmp.get('v.contractList');
        var selectedRows = c.getSelectedRows();
        for (var i = 0; i < selectedRows.length; i++){
            var indexOfStevie = arr.findIndex(j => j.id == selectedRows[i].id);
            cmp.set('v.contractList',arr.splice(indexOfStevie,1));
        }
    }
})