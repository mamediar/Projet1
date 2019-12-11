({
	init: function (cmp, event, helper) {
        var actions = [
            { label: 'Rimuovi', name: 'remove' }
        ];
        cmp.set('v.columns', [
            {label: 'Numero Contratto', fieldName: 'ContractNumber__c', type: 'text'},
            {label: 'Lotto Origine', fieldName: 'OCSLottoId__c', type: 'text'},
            {label: 'Stato', fieldName: 'Status', type: 'text'},
						//{label: '', type: 'button', name: 'removeContract', iconName:'utility:delete',title: 'Rimuovi il contratto dalla lista' }
            {label: '', type: 'button', typeAttributes: {label:'', name: 'removeContract',width:49 , iconName:'utility:delete', title: 'Rimuovi il contratto dalla lista'}}
        ]);
    },

    checkIdLength : function (cmp, event, helper){
        var tempInput = event.getParam("barCode");
        var list = (cmp.get("v.contractList") != null) ? cmp.get("v.contractList") : [];
        //console.log(list.isEmpty());
        //var tempInput = cmp.get("v.inputIdContract");
        //var tempInput = cmp.get("v.inputIdContract") != null ? cmp.get("v.inputIdContract") : 0;
        //var MAXLENGTH = 10;
        //if(tempInput && tempInput.length >= MAXLENGTH){
        var action = cmp.get("c.selectContracts");
        action.setParams({
            'data'    : tempInput,
            'caseID' : cmp.get('v.recordId'),
            'attachmentType' : cmp.get('v.valAllegato')
        });
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var result = response.getReturnValue();
                if(result.contratto == null){
                    cmp.set("v.report", result.message);
                    cmp.set("v.severity", result.statusMessage);
                    cmp.set("v.errorTableFlag", true);
                    //cmp.set("v.messageTableFlag", true);
                }else{
                    //if(list == null) list = [];
                    var tempList = [];
                    list.forEach(function(el){tempList.push(el.Id);});
                    if(tempList.includes(result.contratto.Id)){
                        cmp.set("v.report", 'Il codice è già stato acquisito.');
                        cmp.set("v.severity", 'error');
                        cmp.set("v.errorTableFlag", true);
                    }else{
                        //console.log(JSON.parse(JSON.stringify(list)).keys());
                        cmp.set("v.errorTableFlag", false);
                        list.push(result.contratto);
                        cmp.set("v.contractList", list);
                        cmp.set("v.contractTableFlag", true);
                        //console.log( JSON.stringify(result) );
                    }
                }
            }
        });
        $A.enqueueAction(action);
        //}
    },

    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            /*case 'show_details':
                alert('Showing Details: ' + JSON.stringify(row));
                break;*/
            case 'removeContract' :
            case 'remove':
                helper.removeBook(cmp, row);
                var list = cmp.get("v.contractList") != null ? cmp.get("v.contractList") : [];
                if(list <= 0){
                    cmp.set("v.errorTableFlag", false);
                    cmp.set("v.contractTableFlag", false);
                }
                break;
        }
    },

    handleChange : function(cmp, event, helper){
        var isBlankRadio = cmp.get('v.valAllegato') == '';
        cmp.set('v.placeholder', (!isBlankRadio)?'Inserire codice pratica...':cmp.get('v.valAllegato'));
    },
    
    showToast : function(component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        title : "Operazione completata",
        type : 'success',
        message : "Il Record è stato aggiornato con Successo."
    });
    toastEvent.fire();
    var navigate = component.get('v.navigateFlow'); 
        navigate("NEXT");           
    },
    
    ClickNext : function(component, event, helper) {
        var navigate = component.get('v.navigateFlow'); 
        navigate("NEXT");            
    }
    
})