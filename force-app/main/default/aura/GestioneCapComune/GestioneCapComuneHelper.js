({
	init: function (cmp, event, helper) {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        cmp.set('v.columns', [
            {label: 'CAP', fieldName: 'CAP__c', type: 'text'},
            {label: 'Comune', fieldName: 'Comune__c', type: 'text'},
            {label: 'Zona', fieldName: 'ZoneName', type: 'text'},
            {label: '', type: 'button', typeAttributes:{label: 'Assegna Zona',title: 'Assegna Zona',name:'assegnaZona'}}
        ]);
        var action = cmp.get("c.initApex");
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {
                var initWrapper= response.getReturnValue();
                cmp.set('v.capComuniMap', initWrapper.capComuniMap); 
                //cmp.set('v.branches',initWrapper.branches);
                cmp.set('v.branches',cmp.get("v.branchSel"));
                var filialeSelezionata =  cmp.get('v.branches');
                if(!cmp.get('v.branchOCSExternalId')){
                    if(initWrapper.branches.length!==0){
                        //cmp.set('v.branchOCSExternalId', initWrapper.branches[0].OCS_External_Id__c);
                        cmp.set('v.branchOCSExternalId', filialeSelezionata[0].OCS_External_Id__c);
                    }
                }
                cmp.set('v.branchOCSExternalId', filialeSelezionata[0].OCS_External_Id__c); //DP
                var capComuniList=initWrapper.capComuniMap[cmp.get('v.branchOCSExternalId')];
                if(capComuniList)
                {
                capComuniList.forEach(function(element) {
                    if(element.Zone__r){
                        element.ZoneName = element.Zone__r.Name;
                    }
                });
                }
                cmp.set('v.capComuniList',capComuniList );
                cmp.set('v.zoneList', initWrapper.zoneList[cmp.get('v.branchOCSExternalId')]);
                cmp.set('v.zonePerFiliale', initWrapper.zoneList);

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

    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'assegnaZona':
                helper.openPopUp(cmp, event, helper,row);
                break;
            default:
                break;
        }
    },

    openPopUp: function(cmp, event, helper,row){ 
        if( cmp.get("v.zoneList") && cmp.get("v.zoneList").length>0){
            cmp.find("theStaticModal").openModal();
            var selectedRow = cmp.get("v.capComuniList").find(x =>{
                                    return x.Id == row.Id;
                                });
            if(!selectedRow.Zone__c){
                selectedRow.Zone__c=cmp.get("v.zoneList")[0].Id;
            }
            cmp.set("v.selectedRow",selectedRow);
        }
        else{
            helper.showToast('Nessuna zona presente per questa filiale','error');
        }
    },        

    saveNewZone: function(cmp, event, helper){
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get("c.updateCapComune");
        action.setParams({capComuniList:[cmp.get("v.selectedRow")]});
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {
                
                helper.showToast("SALVATAGGIO RIUSCITO","success");
				helper.init(cmp, event, helper);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        }); 
        $A.enqueueAction(action);
        
        
       
        cmp.find("theStaticModal").closeModal();
    },

    onChangeBranchSelect : function(cmp, event, helper){
        console.log('DP sono in onchange Branch di cap comune');
        var branchOCSExternalId= cmp.get('v.branchOCSExternalId');
        if(branchOCSExternalId){
            var zoneList= cmp.get('v.zonePerFiliale')[branchOCSExternalId];
            cmp.set('v.zoneList', zoneList);
            var capComuniList = cmp.get('v.capComuniMap')[branchOCSExternalId];
            cmp.set('v.capComuniList', capComuniList);
        }
    },

    showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },
    
    sendMessageHandler: function(component, event, helper){
        if(event.getParam("message") === "refresh" && event.getParam("channel") === "CapComune"){
            helper.init(component, event, helper);
        }
	},
    
})