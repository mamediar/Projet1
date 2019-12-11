({
    init : function(cmp,event,helper){
        console.log('Inadempimento INit');
        cmp.set('v.tabInadempimento',true);
      
        helper.setOption(cmp);
        
        
        helper.initHelper(cmp);                       
        var cCase = cmp.get('v.campiCase');
        var gravita = cCase.Inadempimento_Grave__c ? 'DP2208' : 'DP2209';
        cmp.set('v.gravitaDettagli', gravita);
       
        var attrMap={'reclamoCompletoSelection':!cCase['Reclamo_Completo__c']?'No':'Si' };     
        Object.keys(attrMap).forEach(function(temp){
            cmp.set('v.'+temp,attrMap[temp]);          
        }
                                    );    
         //if(!cmp.get("v.gravitaDettagli") && cCase.Disposition__c != null) cmp.set("v.gravitaDettagli",cCase.Disposition__r.External_Id__c);
        cmp.set('v.reclamoCompletoOutput',helper.buildInputCompleto(cmp));
      
        helper.getCurrentValues(cmp);
        
    },
    
    setStageInadempimento : function (cmp,event,helper){
        
        cmp.set('v.stageInadempimentoDuplicate', cmp.get('v.stageInadempimento'));
    },
    
    handleChange:function(cmp,event,helper){
        var source = event.getSource();
        if (source.getLocalId() == 'gravita' && cmp.get('v.stageInadempimentoOld') != '4166' && cmp.get('v.stageInadempimentoOld') != '4170') {
            if (source.get('v.value') == 'Uff Legale - Grave') cmp.set('v.stageInadempimento', '4166'); //Step 1 – Start
            else if (source.get('v.value') == 'Uff Legale - Non Grave') cmp.set('v.stageInadempimento', '4171'); //End
        }else if (source.getLocalId() == 'gravita' && (cmp.get('v.stageInadempimentoOld') == '4166' || cmp.get('v.stageInadempimentoOld') == '4170')) {
            if (source.get('v.value') == 'Uff Legale - Grave') cmp.set('v.stageInadempimento', '4169'); //Step 2 – F&T Waiting
            else if (source.get('v.value') == 'Uff Legale - Non Grave') cmp.set('v.stageInadempimento', '4171'); //End
        }
        cmp.set('v.isOk',helper.checkIfOk(cmp));
        cmp.set('v.output',helper.buildOutputObject(cmp));
    },
    
    salvaReclamoInadempimento : function(cmp,event,helper){

        var action=cmp.get('c.salvaReclamoInadempimentoApex');
        action.setParams({'recordId' : cmp.get('v.recordId'),
                          'stageInadempimento' : cmp.get('v.stageInadempimento'),
                          'FTSent' : cmp.get('v.FTSent'),
                          'FTReceived' : cmp.get('v.FTReceived'),
                          'gravita' : cmp.get('v.gravitaDettagli')
                         });
        
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){               
                
            }
            cmp.set("v.isLoading", false); 
        });
        cmp.set("v.isLoading", true);
        $A.enqueueAction(action);
        return true;
    },
    
    handleReclamoCompleto : function(cmp,event,helper){
        if(event.getParam("value") == 'false')
            cmp.set('v.ReclamoCompletoValue', false);   
        else if(event.getParam("value") == 'true')
            cmp.set('v.ReclamoCompletoValue', true);
    },
    
    refreshComponent : function(cmp){
        $A.get('e.force:refreshView').fire();
    }
})