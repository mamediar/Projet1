({
    init : function(cmp, event, helper) 
    {
        helper.helperInit(cmp);
    },
    insertNote : function (cmp,event,helper)
    {
        var note = event.getParam('note');
        var action = cmp.get("c.insertNote");
        action.setParams({'note' : note,
                          'recordId' : cmp.get('v.recordId')});
        $A.enqueueAction(action);
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
        cmp.set('v.radioGroupOptionPrivacyValue',selectedRows[0]['selectRegistration']);
        cmp.set('v.dispositionVisibility',selectedRows[0]['tempRevoca'].indexOf("RATEALE") >= 0 ? 'RATEALE' : selectedRows[0]['tempRevoca']);
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
        console.log('******* change selection');
        if((selectedCard.Action__c == 'OK' || selectedCard.Action__c == 'CON') && selectedCard.dispositionName == '')
        {
            selectedCard.Selected__c = cmp.get('v.radioGroupOptionValue') == 'true' ? true : false ;
            console.log('********* dentro if');
            for(var i = 0;i < retentionList.length ; i++)
            {
                if(retentionList[i].LoanNumber__c == selectedCard.LoanNumber__c)
                {
                    retentionList[i].Selected__c = selectedCard.Selected__c;
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
        cmp.set('v.dispositionVisibility','');
        cmp.set('v.radioGroupOptionRevocaValue','');
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
        cmp.set('v.radioGroupOptionPrivacyValue','');
    },
    
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
    saveSelectionMock : function(cmp,event,helper)
    {
        var dispo = event.getParam('disposition');
        var retention = cmp.get("v.selectedCard");
        var retentionList = cmp.get("v.retentionList");
        console.log("Disposition:" + JSON.stringify(dispo));
        console.log("Retention:" + JSON.stringify(retention))
        retention.Selected__c = cmp.get('v.radioGroupOptionValue') == 'true' ? true : false ;
        retention.tempRevoca = cmp.get('v.radioGroupOptionRevocaValue');
        retention.selectRegistration = cmp.get('v.radioGroupOptionPrivacyValue');      
        var action = cmp.get("c.saveRetentionDisposition");
        action.setParams({
            "disposition": dispo,
            "retention" : retention,
            "tipoRevoca" : cmp.get('v.radioGroupOptionRevocaValue')
        });
        action.setCallback(this, function(response)
                           {
                               console.log("CallBack : ");
                               var toastEvent = $A.get("e.force:showToast");
                               var wrapObject = response.getReturnValue();
                               var check = wrapObject.res;
                               var mess = wrapObject.messError;
                               console.log("wrap Object : " + check +' ----- '+ JSON.stringify(wrapObject));
                               if(check == true)
                               { 
                                   console.log('***********°°°°°°°°°°°' + dispo);
                                   toastEvent.setParams({
                                       "title": "Successo",
                                       "messagge": 'Successo',
                                       "type" : "Success" 	
                                   });
                                   retention.dispositionName = dispo.Name;
                                   retention.Disposition__c = dispo.id;
                                   retention.Gestione_temp = mess;
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
                                   cmp.set('v.selectedCard',retention);
                                   cmp.set('v.retentionList',retentionList);
                                   cmp.set('v.dataTableFlag',false);
                                   cmp.set('v.dataTableFlag',true);
                               }
                               else
                               {
  
                                   toastEvent.setParams({
                                       "title": "Attenzione",
                                       "message": mess,
                                       "type" : "Warning"	
                                   });
                               }
                               toastEvent.fire();
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
            'noteValue' : cmp.get('v.noteValue'),
            });
        console.log('******************** 1 ');
        action.setCallback(this, function(response)
         {
            if(response.getState() == 'SUCCESS' ) 
            {
            	console.log('******************** 2 ');
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
                    setTimeout(function(){ $A.get('e.force:refreshView').fire(); }, 200);
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
                console.log('******************** 4 ');
        
            }
        });
        console.log('******************** 3 ');
        $A.enqueueAction(action);
    }
    
})