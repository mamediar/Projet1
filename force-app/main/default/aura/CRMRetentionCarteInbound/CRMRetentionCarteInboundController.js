({
    init : function(cmp, event, helper) 
    {
        helper.helperInit(cmp);
    },
    
    getCard : function(cmp, event, helper)
    {
        var selectedRows = event.getParam('selectedRows');
        var temp;
        for(var i=0;i<selectedRows.length;i++){
            temp = selectedRows[i]['LoanNumber__c'];
        }        
        console.log("FOR :" + temp + ' -row selected: ' + selectedRows[0]['LoanNumber__c'] + "- Selected" + selectedRows[0].Selected__c);
        cmp.set('v.radioGroupOptionValue',(selectedRows[0]['Selected__c'] == true ? 'true' : 'false'));
        cmp.set('v.radioGroupOptionRevocaValue',selectedRows[0]['tempRevoca']);
        //cmp.set('v.radioGroupOptionRatealeValue',selectedRows[0]['tipoRateale']);
        cmp.set('v.radioGroupOptionPrivacyValue',selectedRows[0]['selectRegistration']);
        cmp.set('v.dispositionVisibility',selectedRows[0]['tempRevoca'].indexOf("RATEALE") >= 0 ? 'RATEALE' : selectedRows[0]['tempRevoca'] == "" ? "null" : selectedRows[0]['tempRevoca']);
        cmp.set('v.selectedCard', selectedRows[0]);
        cmp.set('v.cardVisibility',selectedRows[0]['LoanNumber__c']);
    },
    
    changeSelection : function(cmp,event,helper)
    {
        var scriptGenericName = cmp.get('v.scriptGenericName') +' '+cmp.get('v.radioGroupOptionRevocaValue') ;
        var scriptList = cmp.get('v.scriptList');
        var scriptSelected;
        var selectedCard = cmp.get('v.selectedCard');
        var retentionList = cmp.get('v.retentionList');
        if(selectedCard.Action__c == 'OK' || selectedCard.Action__c == 'CON')
        {
            selectedCard.Selected__c = cmp.get('v.radioGroupOptionValue') == 'true' ? true : false ;
            selectedCard.Gestione_temp = (selectedCard.Selected__c ? "La carta sarà gestita dall'operatore di secondo livello" : '')
            for(var i = 0;i < retentionList.length ; i++)
            {
                if(retentionList[i].LoanNumber__c == selectedCard.LoanNumber__c)
                {
                    retentionList[i].Selected__c = selectedCard.Selected__c;
                    retentionList[i].Gestione_temp = selectedCard.Gestione_temp;
                    console.log("Dentro if cambia valore selected dopo :" + retentionList);
                }
            }
            cmp.set('v.retentionList',retentionList);
            cmp.set('v.selectedCard',selectedCard);
            cmp.set('v.dataTableFlag',false);
            cmp.set('v.dataTableFlag',true); 
        }
        for(var i=0;i<scriptList.length;i++)
        {
            console.log(scriptList[i].Name);
            if(scriptList[i].Name == scriptGenericName)
            {
                scriptSelected = scriptList[i];
                console.log("Dentro IF : " + scriptSelected);
            }
        }
        cmp.set('v.scriptToView',scriptSelected);
        cmp.set('v.radioGroupOptionRevocaValue','null');
        cmp.set('v.dispositionVisibility','null');
        // cmp.set('v.radioGroupOptionRatealeValue','');
        cmp.set('v.radioGroupOptionPrivacyValue','');
    },
    
    changeSelectionRevoca : function(cmp,event,helper)
    {
        var scriptGenericName = cmp.get('v.scriptGenericName') +' '+cmp.get('v.radioGroupOptionRevocaValue') ;
        var scriptList = cmp.get('v.scriptList');
        var scriptSelected;
        var visibility = cmp.get("v.radioGroupOptionRevocaValue");
        for(var i=0;i<scriptList.length;i++)
        {
            console.log(scriptList[i].Name);
            if(scriptList[i].Name == scriptGenericName)
            {
                scriptSelected = scriptList[i];
                console.log("Dentro IF : " + scriptSelected);
            }
        }
        if(visibility.indexOf("RATEALE") >= 0)
        {
            visibility = "RATEALE";
        }
        cmp.set('v.dispositionVisibility',visibility);
        cmp.set('v.scriptToView',scriptSelected);
        // cmp.set('v.radioGroupOptionRatealeValue','');
        cmp.set('v.radioGroupOptionPrivacyValue','');
    },
    
    /* changeSelectionRateale : function(cmp,event,helper)
    {
     	var scriptGenericName = cmp.get('v.scriptGenericName') +' '+cmp.get('v.radioGroupOptionRevocaValue') + ' ' +  cmp.get('v.radioGroupOptionRatealeValue');
        var scriptList = cmp.get('v.scriptList');
        var scriptSelected;
        for(var i=0;i<scriptList.length;i++)
                {
                   	console.log(scriptList[i].Name);
                    if(scriptList[i].Name == scriptGenericName)
                    {
                        scriptSelected = scriptList[i];
                        console.log("Dentro IF : " + scriptSelected);
                    }
                }
        cmp.set('v.scriptToView',scriptSelected);
    }, */
    saveSelection : function(cmp,event,helper)
    {
        var dispo = event.getParam('disposition');
        var dispositionClass = event.getParam('apexClass');
      	console.log('*******' + dispositionClass);
        var retention = cmp.get("v.selectedCard");
        var retentionList = cmp.get("v.retentionList");
        console.log("Disposition:" + JSON.stringify(dispo));
        console.log("Retention:" + JSON.stringify(retention))
        var retSelected = retention.Selected__c;
        retention.Selected__c = cmp.get('v.radioGroupOptionValue') == 'true' ? true : false ;
        retention.tempRevoca = cmp.get('v.radioGroupOptionRevocaValue');
        retention.selectRegistration = cmp.get('v.radioGroupOptionPrivacyValue');      
        var action = cmp.get("c.saveRetentionDisposition");
        action.setParams({
            "disposition": dispo,
            "retention" : retention,
            "apexClass" : dispositionClass
        });
        action.setCallback(this, function(response)
                           {
                               console.log("CallBack : ");
                               var toastEvent = $A.get("e.force:showToast");
                               var wrapObject = response.getReturnValue();
                               var isToExecute = wrapObject.res;
                               if(!isToExecute || (isToExecute && wrapObject.dispositionResult.result))
                               {
                                   console.log("wrap Object : ");
                                   console.log('***********°°°°°°°°°°°');
                                   retention.dispositionName = dispo.Name;
                                   retention.Disposition__c = dispo.Id;
                                   console.log('************+' + JSON.stringify(retention))
                                   for(var i = 0;i < retentionList.length ; i++)
                                   {
                                       if(retentionList[i].LoanNumber__c == retention.LoanNumber__c)
                                       {
                                           retentionList[i].Selected__c =  retention.Selected__c;
                                           retentionList[i].Disposition__c = retention.Disposition__c;
                                           retentionList[i].dispositionName = retention.dispositionName;
                                           retentionList[i].Gestione_temp = retention.Gestione_temp; 
                                           console.log("Dentro if cambia valore selected dopo :" + retentionList);
                                       }
                                   }
                               }
                               else
                               {
                                   retention.Gestione_temp = wrapObject.messagge;
                                   retention.Selected__c = retSelected;
                                   for(var i = 0;i < retentionList.length ; i++)
                                   {
                                       if(retentionList[i].LoanNumber__c == retention.LoanNumber__c)
                                       {
                                           retentionList[i].Gestione_temp = retention.Gestione_temp; 
                                           console.log("Dentro if cambia valore selected dopo :" + retentionList);
                                       }
                                   }
                                   toastEvent.setParams({
                                       "title": "Attenzione",
                                       "message": wrapObject.dispositionResult.messagge,
                                       "type" : "Warning"	
                                   });
                                   
                                   toastEvent.fire();
                               }
                               cmp.set('v.selectedCard',retention);
                               cmp.set('v.retentionList',retentionList);
                               cmp.set('v.dataTableFlag',false);
                               cmp.set('v.dataTableFlag',true);
                           });                  
        $A.enqueueAction(action);
    },
    
    annullaAttivita : function(cmp,event,helper)
    {
        var workspaceAPI = cmp.find("workspace");
        var toastEvent = $A.get("e.force:showToast");
        var recordId = cmp.get('v.recordId');
        var action = cmp.get('c.annullaRichiesta');
        action.setParams({
            "caseId" : recordId 
        });
        action.setCallback(this,function(response){
           	 toastEvent.setParams({
                                           "title": "Successo",
                                           "message": "Caso Eliminato con Successo",
                                           "type" : "Success"	
                                       });
                                       toastEvent.fire();
            workspaceAPI.getFocusedTabInfo().then(function(response) {
									   var focusedTabId = response.tabId;
                                       workspaceAPI.closeTab({tabId: focusedTabId});
                                       })
            
        });
        $A.enqueueAction(action);
    },
    
    completaAttivita : function(cmp,event,helper)
    {
        var action = cmp.get('c.confirmAction');
        action.setParams({
            'caseId': cmp.get('v.recordId'),
            'customer' : cmp.get('v.customer'),
            'listRetention' : cmp.get('v.retentionList'),
            'customerEmail' : cmp.get('v.customerEmail'),
            'customerCell' : cmp.get('v.customerCellulare'),
            'fasciaSelezionata' : cmp.get('v.fasciaSelezionata'),
            'noteValue' : cmp.get('v.noteValue'),
            'isOkRetentionIn' : (!cmp.get('v.checkMessaggeVisibility')),
            'privacySMS' : cmp.get('v.radioGroupOptionConsensoValue')
        });
        action.setCallback(this, function(response)
                           {
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   var workspaceAPI = cmp.find("workspace");
                                   var toastEvent = $A.get("e.force:showToast");
                                   var returnObj = response.getReturnValue();
                                   var check = returnObj.res;
                                   var messError = returnObj.messError;
                                   if(check)
                                   {
                                       toastEvent.setParams({
                                           "title": "Successo",
                                           "message": "Chiudere la chiamata",
                                           "type" : "Success"	
                                       });
                                       toastEvent.fire();
                                     
                                       
									   workspaceAPI.getFocusedTabInfo().then(function(response) {
									   var focusedTabId = response.tabId;
                                       workspaceAPI.closeTab({tabId: focusedTabId});
                                       })
                                   }
                                   else
                                   {
                                       toastEvent.setParams({
                                           "title": "Attenzione",
                                           "message": messError,
                                           "type" : "Warning"	
                                       });
                                       toastEvent.fire();
                                   }
                               }
                           });
        $A.enqueueAction(action);
    },
    handleSelezionaFascia : function(cmp,event,helper)
    {
        var fascia = cmp.find("fasciaOrariaSelezione").get("v.value");
        cmp.set("v.fasciaSelezionata", fascia);
        console.log("*** fascia selezionata :: " + fascia);
        
    }
    
})