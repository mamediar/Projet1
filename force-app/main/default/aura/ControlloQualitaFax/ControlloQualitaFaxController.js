({
    init : function(cmp, event, helper) {
        var action = cmp.get('c.getUserInfo');
        action.setParams({
            'recordId' : cmp.get('v.recordId')
        });            
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
               // helper.setToastUpdateOwnerTask(cmp);
                
            }
        });
        $A.enqueueAction(action);        
        helper.setOptions(cmp);
    },
    
    checkValues : function(cmp,event,helper){             
        var identificazione = cmp.find('Identificazione').get('v.value');
        var operatività = cmp.find('Operatività').get('v.value');
        var noteOCS = cmp.find('NoteOCS').get('v.value');        
        var archiviazione = cmp.find('Archiviazione').get('v.value');
        var sla = cmp.find('sla').get('v.value');
        
        cmp.set('v.identificazioneValue',identificazione);
        cmp.set('v.operativitaValue',operatività);
        cmp.set('v.noteOCSValue',noteOCS);
        cmp.set('v.archiviazioneValue',archiviazione);
        cmp.set('v.slaValue',sla);     
    },
    
    confirmTask : function(cmp,event,helper){
        if(helper.checkInputData(cmp)){
            var action = cmp.get('c.confirmTaskCQ');
            action.setParams({
                'identificazione' : cmp.get('v.identificazioneValue'),
                'operativita' : cmp.get('v.operativitaValue'),
                'noteOCS' : cmp.get('v.noteOCSValue'),
                'archiviazione' : cmp.get('v.archiviazioneValue'),
                'sla' : cmp.get('v.slaValue'),
                'note' : cmp.get('v.note'),
                'recordId' : cmp.get('v.recordId')
            });            
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    helper.setToastTaskSuccess(cmp); 
                    var workspaceAPI = cmp.find("workspace");
                    workspaceAPI.getFocusedTabInfo().then(function(response) {
                        var tabId = !response.parentTabId ? response.tabId : response.parentTabId;
                        workspaceAPI.closeTab({tabId: tabId});
                    });
                    
                }
            });
            $A.enqueueAction(action);
        } else
            helper.setToastTaskFail(cmp);
        
    }
    
    
})