({

    showSpinner : function(cmp,event){
        console.log('mostro lo spinner');    
        cmp.set("v.spinnerClass","");
    },
    hideSpinner: function(cmp,event){
        var channel = event.getParam("channel");
        console.log('nascondo lo spinner - channel: ' + channel);  
        if(channel=='TMKTG'){
            cmp.set("v.spinnerClass","slds-hide");   
        }        
    },
    init : function(cmp,event,helper){
        cmp.set('v.idTab', "scriptChiamata");
        let caso = cmp.get('v.CaseRecord');
        console.log('vediamo se e cqs ',caso.CampaignId__r.ActionCode__c)        
        if(caso.ActivityType__c == 'TMKCC'){ cmp.set('v.dispPresel1', 'DP1200')} else {cmp.set('v.dispPresel1','DP1179') }  
        if(caso.ActivityType__c == 'TMKPP' && caso.CampaignId__r.ActionCode__c == 'CQS') {cmp.set('v.dispPresel1','DP1228') }  
       
    },
    switchTab : function(cmp, event, helper) {
        let tab = event.getParam('TabSel');
        let dispPresel1 = event.getParam('dispPresel1');
        let dispPresel2 = event.getParam('dispPresel2');
        let dispPresel3 = event.getParam('dispPresel3');
        let checkAttr = event.getParam('checkboxAttribute');
        
        console.log(checkAttr)
        cmp.set('v.dispPresel1', dispPresel1);
        cmp.set('v.dispPresel2', dispPresel2);
        cmp.set('v.dispPresel3',dispPresel3);
        cmp.set('v.checkboxAttribute', checkAttr);
        cmp.set('v.idTab', tab);
        console.log(cmp.get('v.dispPresel2'))

    },
    closeTab : function(cmp,event,helper){
    
        let boolCloseTab = event.getParam('boolTab');
        if(boolCloseTab){
            var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
        }   
        
       
    }
})