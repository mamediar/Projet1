({
    init : function(cmp){
        var cCase=cmp.get('v.campiCase');
        
        cmp.set('v.ident',cCase['Id']);

        //Recupero il profilo
        this.showSpinner(cmp);
        
        var action=cmp.get('c.getProfileLevelUser');
       
        action.setParams({societa:cCase.Referenced_Company__c});
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.profileLevel',resp.getReturnValue());  
             
            }
            
            this.hideSpinner(cmp);
        });
        $A.enqueueAction(action);
        this.showSpinner(cmp);
        //Recupero le info relative al case
        var action2=cmp.get('c.getCase');
        action2.setParams({idCase:cCase['Id']});
        action2.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.case',JSON.parse(resp.getReturnValue())); 
                   this.isAuthorizzed(cmp);
            }
            
            this.hideSpinner(cmp);
        });
        $A.enqueueAction(action2);
        
    },
    
    autorizzaRespingi : function(cmp, label){
        var c=cmp.get('v.case');
        this.showSpinner(cmp);
        var action=cmp.get('c.autorizzaRespingiCtrl');
        action.setParams({
            caseObj: JSON.stringify(c),
            lbl: label
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.case',JSON.parse(resp.getReturnValue()));  
               this.isAuthorizzed(cmp);
            }
            
            this.hideSpinner(cmp);
        });
        $A.enqueueAction(action);
    },
    
    isAuthorizzed : function(cmp){
        var cas =  cmp.get('v.case');
        if(cas.Tipo_Autorizzazione__c == 'Nessuno') cmp.set('v.isAuthorizzed', true);
        else if(cas.Tipo_Autorizzazione__c == '1° livello' && cas.Autorizzazione_Livello_1__c == '4153') cmp.set('v.isAuthorizzed', true);
            else if(cas.Tipo_Autorizzazione__c == '2° livello' && cas.Autorizzazione_Livello_2__c == '4156') cmp.set('v.isAuthorizzed', true);
        if(cmp.get('v.isAuthorizzed')){
            var cmpEvent = cmp.getEvent("autorizza");
            cmpEvent.fire();
        }
    },
    
    
    showSpinner: function(cmp){
        var spinner = cmp.get("v.spinner");
        spinner++;
        cmp.set("v.spinner", spinner);
    },
    
    hideSpinner: function(cmp){
        var spinner = cmp.get("v.spinner");
        spinner--;
        cmp.set("v.spinner", spinner);
    }   
    //Boris Fine

})