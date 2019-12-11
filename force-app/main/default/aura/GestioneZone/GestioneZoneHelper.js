({
	initZoneList: function (cmp, event, helper) {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        cmp.set('v.columns', [
            {label: 'Zona', fieldName: 'Name', type: 'text', editable: true},
            {label: '', type: 'button',initialWidth:80, typeAttributes:{title: 'Cancella',name:'delete',iconName: 'utility:delete'}}
        ]);
        var action = cmp.get("c.initApex");
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {

                var initWrapper= response.getReturnValue();
                //cmp.set('v.branches',initWrapper.branchList);
                cmp.set('v.branches',cmp.get("v.branchSel"));
                var filialeSelezionata =  cmp.get('v.branches');
                console.log('DP filialeSelezionata: '+filialeSelezionata[0].OCS_External_Id__c);
                var externalIdBranch;
                if (cmp.get("v.branchOCSExternalId")){
                    externalIdBranch = cmp.get("v.branchOCSExternalId"); 
                    console.log('DP ho trovato external Id branch');
                }else{
                    if(initWrapper.branchList.length!==0){
                        //cmp.set('v.branch',initWrapper.branchList[0]);
                        cmp.set('v.branch',cmp.get("v.branchSel"));
                        //externalIdBranch = initWrapper.branchList[0].OCS_External_Id__c;
                        externalIdBranch = filialeSelezionata[0].OCS_External_Id__c;
                        console.log('DP sono in else externalIdBranch: '+externalIdBranch);
                    }
                }
                cmp.set('v.data',initWrapper.ZonePerFiliale[externalIdBranch]);
                cmp.set('v.ZonePerFiliale',initWrapper.ZonePerFiliale);
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
        var zoneList = cmp.get('v.ZonePerFiliale')[branchOCSExternalId] ? cmp.get('v.ZonePerFiliale')[branchOCSExternalId] : [];
        cmp.set('v.branch', cmp.get('v.branches')
        .find(branch => {return branch.OCS_External_Id__c===branchOCSExternalId}) );
        cmp.set('v.data',zoneList);
    },
    
    handleSave: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        var data = cmp.get('v.data');
        var isValid = true;

         for(var i=0;i < data.length;i++)
        {
             for(var j=0;j < draftValues.length;j++)
             {
                 if(data[i].Id == draftValues[j].Id)
                {
                    if(helper.checkDuplicated(cmp, event, helper,draftValues[j].Name)){
                        helper.showToast("Zona \""+draftValues[j].Name+"\" già presente","error");  
                        isValid = false;
                    }
                    else{
                        data[i].Name = draftValues[j].Name;
                    } 
                
                }
            }  
        }
        if(isValid){
            helper.saveZone(cmp, event, helper);
            cmp.set('v.draftValues',[]);
            cmp.set('v.data',data);
        }
        
    },
    
    
    deleteZone: function (cmp, event, helper,row) {
       var listaZone = cmp.get("v.data");
       var listaZoneToDelete = cmp.get("v.listaZoneToDelete");
        
       var zoneToDelete = listaZone.find(function( obj ) {
          return obj.Id === row.Id;
        });
        if(zoneToDelete.Id && !zoneToDelete.Id.includes("row-"))
        {
        listaZoneToDelete.push(zoneToDelete);
        }
        listaZone = listaZone.filter(function( obj ) {
          return obj.Id !== row.Id;
        });
        cmp.set("v.data",listaZone);
        cmp.set("v.listaZoneToDelete",listaZoneToDelete);
        helper.saveZone(cmp, event, helper);
	},
    
    addZone: function (cmp, event, helper,row) {
        
        var listaZone = cmp.get("v.data");
        if(!listaZone){
            listaZone=[];
        }
        var input = cmp.find("inputAddZone");
        var newZoneName = cmp.get("v.newZoneName");
        input.focus();
        event.getSource().focus();
        if (input.checkValidity()){
            
            if(helper.checkDuplicated(cmp, event, helper,newZoneName)){
                helper.showToast("Zona \""+newZoneName+"\" già presente","error");
            }else{
                var Branch =  cmp.get("v.branch");
                listaZone.push({Id:'row-'+listaZone.length,Name : newZoneName,Branch__c : Branch.Id});
                cmp.set("v.data",listaZone);
                helper.saveZone(cmp, event, helper);
                cmp.set("v.newZoneName","");
                
            }
        }
	},
    
    saveZone: function (cmp, event, helper) {
        var data = cmp.get("v.data");
        
        data.forEach(function(x){ 
            if(x.Id && x.Id.includes("row-"))
            {
                x.Id = null;             
            }
        } );
        var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
        var action = cmp.get("c.upsertZone");
        
        action.setParams({ theZoneList : data,deleteZoneList : cmp.get("v.listaZoneToDelete")}); 
        action.setCallback(this, function(response) {
            spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.showToast("SALVATAGGIO RIUSCITO","success");
                helper.initZoneList(cmp, event, helper);
                cmp.set("v.listaZoneToDelete",[]);
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
    
    showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },    
    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        //alert('action'+action+' row'+row);
        switch (action.name) {
            case 'delete':
                helper.deleteZone(cmp, event, helper,row);
                break;
            default:
                break;
        }
    },

    checkDuplicated: function(cmp,event,helper,newZoneName){
        var listaZone = cmp.get("v.data");
        
        var similarZone=false;
        if(listaZone){
            similarZone = listaZone.find(x => {
                return x.Name === newZoneName;
            });
        }
        if(similarZone){
            return true;
        }else{
            return false;
        }
        
    },

    refreshdMsg: function() { 
        var sendMsgEventSlot = $A.get("e.ltng:sendMessage"); 
        sendMsgEventSlot.setParams({
                 "message": "refresh", 
                 "channel": "PianificaSlot" 
        }); 
        sendMsgEventSlot.fire(); 
        var sendMsgEventCapComune = $A.get("e.ltng:sendMessage"); 
        sendMsgEventCapComune.setParams({
                 "message": "refresh", 
                 "channel": "CapComune" 
        }); 
        sendMsgEventCapComune.fire(); 
    },
    
    handleApplicationEvent : function(cmp, event) {
        var branch = event.getParam("branch");

        // set the handler attributes based on event data
        cmp.set("v.messageFromEvent", message);
        var numEventsHandled = parseInt(cmp.get("v.numEvents")) + 1;
        cmp.set("v.numEvents", numEventsHandled);
    }
})