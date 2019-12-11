({
    init:function(cmp,event,helper){

        var x = cmp.get('v.showDecisione');
        

        cmp.set('v.tabDettagli',true);
        var cCase = cmp.get('v.campiCase');
        var action = cmp.get('c.getModInvio');
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.modalitaList', resp.getReturnValue()['modList']);
                var attrMap={'risarcimentoSelection':!cCase['Compensazione__c']?'No':'Si',
                             'abbuonoSelection':!cCase['Abbuono_Richiesta__c']?'No':'Si',
                             'standAloneSelection':!cCase['Stand_Alone__c']?'No':'Si',
                             'rimborsoSelection':!cCase['Has_Rimborso__c']?'No':'Si',
                             'risarcimentoValue':cCase['Importo_Compensazione__c'],
                             'abbuonoValue':cCase['Importo_Abbuono_Richiesta__c'],
                             'rimborsoValue':cCase['Importo_Rimborso__c'],
                            };
                Object.keys(attrMap).forEach(function(temp){
                    cmp.set('v.'+temp,attrMap[temp]);
                  
                });
                helper.getDecisione(cmp);
                helper.setScadenzaReclamoReadOnly(cmp,event,helper);
            }
         
            cmp.set('v.risarcimentoOutput',helper.buildInputRisarcimento(cmp));
            cmp.set('v.abbuonoOutput',helper.buildInputAbbuono(cmp));
            cmp.set('v.rimborsoOutput',helper.buildInputRimborso(cmp));
            
            console.log('risarcimentoOutput = ' + cmp.get('v.risarcimentoOutput'));
            cmp.set('v.isOk',helper.checkIfOk(cmp));
            cmp.set('v.outputObj',helper.buildOutputObj(cmp));
            console.log('v.outputObj = ' + cmp.get('v.outputObj'));
        });
        $A.enqueueAction(action);
         //var a = cmp.get('c.handleChange');
        //$A.enqueueAction(a);
        helper.getCurrentModalita(cmp);
    },
    
    handleChange:function(cmp,event,helper){
        cmp.set('v.isOk',helper.checkIfOk(cmp));
        cmp.set('v.outputObj',helper.buildOutputObj(cmp));
    },
    
    reserModalitaInvioDettagliForInit: function(cmp,event,helper){
        cmp.set('v.modalitaInvioDettagliForInit','Selezionare Modalità');
    },

    getValueDecisione:  function(cmp,event,helper){
        
        helper.getDecisione(cmp);
    }
})