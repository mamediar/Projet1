({
    
    getDomandaNoRicordoFinanziamentoPolizzaSi: function (component, event, helper) {
        if (component.get('v.risposta')) {
            var risposte = component.get('v.risposta');
        } else {
            var risposte = component.get('v.rispondeQuezione');
        }
        risposte.D5__c = "Si";
        component.set('v.rispondeQuezione', risposte);
        component.set('v.risposta', risposte);
        component.set('v.PrimaDomanda',true);
        
        helper.checkFlusso1( component, event );
    },

    getDomandaNoRicordoFinanziamentoPolizzaNo: function (component, event, helper) {
        if (component.get('v.risposta')) {
            var risposte = component.get('v.risposta');
        } else {
            var risposte = component.get('v.rispondeQuezione');
        }
        risposte.D5__c = "No";
        component.set('v.rispondeQuezione', risposte);
        component.set('v.risposta', risposte);
        component.set('v.PrimaDomanda',true);
        
        var IntervistaObj = component.get('v.nuovaIntervista');
        var name = component.get('v.nuovaIntervista').COM_NomeCliente__r.Name;
        component.set("v.quezione2", 'Un\'ultima domanda '+component.get("v.status")+' ' + name + ': si ritiene soddisfatto delle modalità di proposizione e vendita della copertura assicurativa facoltativa?')
        //component.set("v.FlagFinanzPolizza", true);
        
        helper.checkFlusso1( component, event );


    },

    setParentFlag1No: function (component, event, helper) {
        if (component.get('v.risposta')) {
            var risposte = component.get('v.risposta');
        } else {
            var risposte = component.get('v.rispondeQuezione');
        }
        //risposte.D7__c = "No";
        risposte.D6__c   = "NO";
        component.set('v.rispondeQuezione', risposte);
        component.set('v.risposta', risposte);
        component.set('v.UltimaDomanda',true);
        
        //component.set('v.showButton', false);
        if (component.get('v.risposta')) {
            var risposte = component.get('v.risposta');
        } else {

            var risposte = component.get('v.rispondeQuezione');
        }
        
        helper.checkFlusso1( component, event );
        
    },

    setParentFlag1Si: function (component, event, helper) {
        if (component.get('v.risposta')) {
            var risposte = component.get('v.risposta');
        } else {
            var risposte = component.get('v.rispondeQuezione');
        }
        //risposte.D7__c = "No";
        risposte.D6__c   = "NO";
        component.set('v.rispondeQuezione', risposte);
        component.set('v.risposta', risposte);
        component.set('v.UltimaDomanda',true);
        //component.set('v.showButton', false);
        //----------------------------------------------------------------------------------//
        helper.checkFlusso1( component, event );

    },
    
    getDomandaSiPerche2No: function (component, event, helper) {
        if (component.get('v.risposta')) {
            var risposte = component.get('v.risposta');
        } else {
            var risposte = component.get('v.rispondeQuezione');
        }
        var UltimaDomandaChecked = component.get("v.UltimaDomanda");
        risposte.D7__c = "No";
        component.set('v.rispondeQuezione', risposte);
        component.set('v.risposta', risposte);
        if( UltimaDomandaChecked == true )
        {
            component.set('v.showButton', true);
        }
        component.set('v.motivazioneSi', false);
        component.set('v.selectTerminaQuezioneNo', true);

        //----------------------------------------------------------------------------------//
        component.set('v.RecessoDomandaNo',true);
        helper.checkFlusso1( component, event );
    },
     
    getDomandaSiPerche2Si: function (component, event, helper) {
        if (component.get('v.risposta')) {
            var risposte = component.get('v.risposta');
        } else {
            var risposte = component.get('v.rispondeQuezione');
        }

        risposte.D7__c = "Si";
        component.set('v.rispondeQuezione', risposte);
        component.set('v.risposta', risposte);
        component.set('v.showButton', false);
        component.set('v.motivazioneSi', true);
        component.set('v.selectTerminaQuezioneNo', false);
        //----------------------------------------------------------------------------------//
        component.set('v.RecessoDomandaSi',true);
        component.set("v.RecessoRispostaNote",false);
        component.set("v.RecessoDomandaNo",false);

        helper.checkFlusso1( component, event );
    },

    concludi: function (component, event, helper) {
        var selectTerminaQuezioneNoFlag = component.get("v.selectTerminaQuezioneNo");
        //alert('selectTerminaQuezioneNoFlag->'+selectTerminaQuezioneNoFlag);
        if (!component.get('v.selectTerminaQuezioneNo')) 
        {
            //alert('component.find-->'+component.find('assTracc'));
            var validExpense = component.find('assTracc').reduce(function (validSoFar, inputCmp) {
                // Displays error messages for invalid fields
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                helper.concludi(component);
            }
        }else{
            helper.concludi(component);
        }
    },

    TerminaIntervista: function (component, event, helper) {
        var risposte = component.get("v.risposta");
        console.log('Response', JSON.stringify(risposte));
        /*
                  var intervista=component.get('v.nuovaIntervista');            //var intervista = component.get('v.nuovaIntervista');
                   intervista.COM_Stato_Avanzamento_IntervistaASS__c ='Conclusa';
        
                   var action = component.get('c.updateIntervista');
                   action.setParam('param',intervista);
                   action.setCallback(this, function (response)
                   {
                        var state = response.getState();
                        if ( state === 'SUCCESS' ) 
                        {
                            component.set('v.nuovaIntervista', response.getReturnValue());
                            console.log('in success',response.getReturnValue());
                            //helper.showToast('Stato aggiornato in "Conclusa".Salvataggio con successo', 'SUCCESS');
                            component.set('v.nonRisposta',false);
                        }else{
                            helper.showToast('Salvataggio non successo', 'ERROR');
                        }
                    });
                   $A.enqueueAction(action);
        
                   risposte.Intervista__c = intervista.Id;
                   console.log('risposte',risposte);
                   console.log('Intervista Id',intervista.Id);
                   var action1 = component.get("c.addResponseAssicurativo");
                       action1.setParams({
                               "respdomanda":risposte
                       });
                   action1.setCallback(this, function(response)
                   {
                      //store state of response
                      var state = response.getState();
                      if( state === "SUCCESS" )
                      {
                          console.log('01-04.2019');
                          // component.set('v.risposta', JSON.stringify(response.getReturnValue()));
                          console.log('response.getReturnValue()'+ JSON.stringify(response.getReturnValue()));
                          //helper.showToast('Salvataggio Risposta con successo!', 'SUCCESS');
                          var eventGoFiliali = $A.get("e.c:eventNavigationAssicurativoPratiche");
                              eventGoFiliali.fire();
                      }else{
                          var errors = response.getError();
                          if (errors) 
                          {
                            if (errors[0] && errors[0].message) 
                            {
                                console.log("Error message: " +errors[0].message);
                            }
                          }else{
                            console.log("Unknown error");
                          }
                      }
                  });
                  $A.enqueueAction(action1);*/


    },
    
    handleRadioClick: function (component, event, helper) {
        var responde = event.getSource().get('v.value');
         if (component.get('v.risposta')) {
            var risposte = component.get('v.risposta');
        } else {
            var risposte = component.get('v.rispondeQuezione');
        }

        risposte.D8__c = responde;
        //alert('responde:'+responde);
        if (responde === "altro") {
            component.set("v.showTextareaRequired", true);
        }
        else {
            component.set("v.showTextareaRequired", false);
        }
        component.set("v.RecessoRispostaNote",true);
        helper.checkFlusso1( component , event );
       
    }
})