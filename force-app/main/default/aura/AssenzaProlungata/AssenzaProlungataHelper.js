({
	init: function (cmp, event, helper) {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        cmp.set('v.columns', [
            {label: 'Risorsa', fieldName: 'Risorsa_Name__c', type: 'text'},
			{label: 'Data Inizio', fieldName: 'StartDate__c', type: 'text'},
			{label: 'Data Fine', fieldName: 'EndDate__c', type: 'text'},
            {label: 'Motivo Assenza', fieldName: 'MotivazioneAssenzaLabel', type: 'text'},
            {label: '', type: 'button',typeAttributes:{title: 'Modifica',name:'edit',iconName: 'utility:edit'}},
            {label: '', type: 'button',typeAttributes:{title: 'Cancella',name:'delete',iconName: 'utility:delete'}}
        ]);
        var action = cmp.get("c.initApex");
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {
                var initWrapper= response.getReturnValue();
                //cmp.set('v.branches',initWrapper.branches);
                cmp.set('v.branches',cmp.get("v.branchSel"));
                var filialeSelezionata =  cmp.get('v.branches');
                var externalIdBranch;
                if (cmp.get("v.branchOCSExternalId")){
                    //externalIdBranch = cmp.get("v.branchOCSExternalId");
                    externalIdBranch = filialeSelezionata[0].OCS_External_Id__c;
                }else{
                    cmp.set('v.branch',initWrapper.branches[0]);
                    //externalIdBranch = initWrapper.branches[0].OCS_External_Id__c;
                    externalIdBranch = filialeSelezionata[0].OCS_External_Id__c;
                }
                

                cmp.set('v.data',initWrapper.assenzePerFiliale[externalIdBranch]);
                cmp.set('v.assenzePerFiliale',initWrapper.assenzePerFiliale);
                cmp.set('v.filialistiPerFiliale',initWrapper.filialistiPerFiliale);
                cmp.set('v.filialistiList',initWrapper.filialistiPerFiliale[externalIdBranch]);
                
                cmp.set('v.TypeSelectOptions',initWrapper.motivoAssenzaPicklist);
                cmp.set('v.Today',initWrapper.today);
            }
            else if(response.getState()=='ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                                 helper.showToast("Errore: " + 
                                 errors[0].message,'error');
                    }else {
                        console.log("Unknown error");
                        helper.showToast('Errore generico','error');
                    }
                } else {
                    console.log("Unknown error");
                    helper.showToast('Errore generico','error');
                }
            }
            
        }); 
        $A.enqueueAction(action); 
	
    },

    onChangeBranchSelect: function(cmp, event, helper) {
        var branchOCSExternalId = cmp.get('v.branchOCSExternalId');
        
        cmp.set('v.branch', cmp.get('v.branches')
        .find(branch => {return branch.OCS_External_Id__c===branchOCSExternalId}) );

        cmp.set('v.data',cmp.get('v.assenzePerFiliale')[branchOCSExternalId]);
        cmp.set('v.filialistiList',cmp.get('v.filialistiPerFiliale')[branchOCSExternalId]);
        console.log('DP v.filialistiList: '+cmp.get('v.filialistiList'));
    },

    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit':
                helper.editAssenza(cmp, event, helper,row);
                break;
            case 'delete':
                helper.deleteAssenza(cmp, event, helper,row);
                break;
            default:
                break;
        }
    },

    addAssenza: function (cmp, event, helper) {    
        cmp.set('v.isNew',true);
        var motivoAssenza = cmp.get("v.TypeSelectOptions")[0].value;
        if(cmp.get("v.filialistiList") && cmp.get("v.filialistiList").length > 0){
            var risorsaFiliale = cmp.get("v.filialistiList")[0];
            cmp.set('v.item',{MotivazioneAssenza__c : motivoAssenza,RisorsaFiliale__c : risorsaFiliale.Id, RisorsaFiliale__r : risorsaFiliale,StartDate__c : cmp.get('v.Today'),EndDate__c : cmp.get('v.Today')});
            cmp.find("theStaticModal").openModal();
        }else{
            helper.showToast('Errore : non sono presenti filialisti per questa filile','error');
        }

    },
    editAssenza: function (cmp, event, helper,row) {    
        cmp.set('v.isNew',false);
        var item = cmp.get('v.data').find(x => {
           return x.Id == row.Id;
        })
        cmp.set('v.item',item);
        cmp.find("theStaticModal").openModal();
    },

    deleteAssenza: function (cmp, event, helper,row) {    
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var item = cmp.get('v.data').find(x => {
            return x.Id == row.Id;
         })
        var action = cmp.get("c.deleteAssenzaApex");
        action.setParams({ theAssenza : item}); 
        action.setCallback(this, function(response) {
            spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.showToast("SALVATAGGIO RIUSCITO","success");
                helper.init(cmp, event, helper);
                helper.refreshdMsg();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        helper.showToast("Error message: " + errors[0].message,"error");
                    }
                    else
                    { helper.showToast("Errore generico","error");}
                } else {
                    helper.showToast("Errore generico:","error");
                }
            }
        });
        $A.enqueueAction(action);
    },
  
    saveAssenza: function (cmp, event, helper) {


        var inputList = cmp.find("inputDate");
        var isValid = true;
        inputList.forEach(input => {
            input.focus();
            isValid = input.checkValidity() && isValid;
        });

        if (isValid){
            if(cmp.get('v.item.StartDate__c') > cmp.get('v.item.EndDate__c')){
                helper.showToast("Errore Data Fine deve essere maggiore o uguale di Data Inizio","error");
            }else{
                helper.upsertAssenza(cmp, event, helper);   
            }
            
        }
        else{
            helper.showToast("Valorizzare le Date","error");
        }

        

    },

    upsertAssenza: function (cmp, event, helper) {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get("c.upsertAssenzaApex");
        action.setParams({ theAssenza : cmp.get("v.item"),ocsCode : cmp.get('v.branch.OCS_External_Id__c')}); 
        action.setCallback(this, function(response) {
            spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result.isError === 'false'){
                    helper.showToast("SALVATAGGIO RIUSCITO","success");
                    helper.init(cmp, event, helper);
                    cmp.find("theStaticModal").closeModal();
                    helper.refreshdMsg();
                }else if (result.isError === 'true'){
                    helper.showToast(result.errorMessage,"error");
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        helper.showToast("Error message: " + errors[0].message,"error");
                    }
                    else
                    { helper.showToast("Errore generico","error");}
                } else {
                    helper.showToast("Errore generico:","error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    closePopUp: function(cmp, event, helper){ 
        cmp.find("theStaticModal").closeModal();
    },

    showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },

    refreshdMsg: function() { 
        var sendMsgEvent = $A.get("e.ltng:sendMessage"); 
        sendMsgEvent.setParams({
                 "message": "refresh", 
                 "channel": "PianificaSlot" 
        }); 
        sendMsgEvent.fire(); 
    }
})