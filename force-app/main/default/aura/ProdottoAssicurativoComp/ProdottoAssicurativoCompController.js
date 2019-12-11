({
    getComodityCheckList : function (component, event, helper){
        helper.getTextListAssicurativos(component);
    },
	
    getDomandaProdottoSi: function (component, event, helper)
    {
            var intervista = component.get('v.nuovaIntervista');
            var name = component.get('v.nuovaIntervista').COM_NomeCliente__r.Name;
            if(component.get('v.risposta')){

                var risposte = component.get('v.risposta');
            }else{

                var risposte = component.get('v.rispondeQuezione');
            }
            console.log('Response', JSON.stringify(risposte));
            risposte.D3__c = "Si";
            console.log('response', risposte.D3__c);
            component.set('v.rispondeQuezione',risposte);
            component.set('v.risposta',risposte);
            console.log('Response', component.get('v.rispondeQuezione'));
            //-------------------------------------------------------------------------------------------//
             component.set('v.assicurativoPerche',true);
             component.set('v.isShownSottoscirtta',false);
             component.set('v.assicurativoTracciaturaRecesso',true);
             component.set('v.isShownForNo',false);
            //-------------------------------------------------------------------------------------------//
            var FlagNonConn = component.get('v.indexFlag');
            if( FlagNonConn == true )
            {
                component.set('v.isShownSottoscirtta',true);

            }
        
            var comodityCheck     = component.get('v.comodityCheklist');
            var NumAssicurazione  = component.get("v.NumeroAssicurazioneStr1");
            
                comodityCheck     = comodityCheck.filter(
                                              row =>
                                              row.COM_CRMflag_prod_sani_non_conn__c === "S" );
        
        
            if( comodityCheck.length > 1 )
            {
                component.set('v.Frase_SP_1',' si ricorda che le polizze denominate ');
                component.set('v.Frase_SP_2',' da Lei sottoscritte, hanno una durata pari a ');
            }else{
                component.set('v.Frase_SP_1',' si ricorda che la polizza denominata ');
                component.set('v.Frase_SP_2',' da Lei sottoscritta, ha una durata pari a ');
            }
            var StringAssicurazioniTipoPolizza = ' '; 
            var StringNumMesiAssic             = ' ';
           
        
            for( var i = 0 ; i < comodityCheck.length ; i ++ )
            {
                 
                     if( comodityCheck.length == 1 )
                     {
                         StringAssicurazioniTipoPolizza  = StringAssicurazioniTipoPolizza+comodityCheck[i].COM_CRMTipo__c;
                         StringNumMesiAssic              = StringNumMesiAssic+comodityCheck[i].COM_CRMCalcolo_giorni_recesso__c;
                         console.log('--01--');
                     }else{
                         console.log('comodityCheck.length:'+comodityCheck.length);
                         if( i == (comodityCheck.length - 1) )
                         {
                         StringAssicurazioniTipoPolizza  = StringAssicurazioniTipoPolizza+comodityCheck[i].COM_CRMTipo__c;
                         StringNumMesiAssic              = StringNumMesiAssic+comodityCheck[i].COM_CRMCalcolo_giorni_recesso__c;
                         console.log('--02--');
                         }else{
                         StringAssicurazioniTipoPolizza  = StringAssicurazioniTipoPolizza+comodityCheck[i].COM_CRMTipo__c+', ';
                         StringNumMesiAssic              = StringNumMesiAssic+comodityCheck[i].COM_CRMCalcolo_giorni_recesso__c+', ';
                         console.log('--03--');
                         }
                     }
                 
            }
            component.set('v.stringAssicurazione',StringAssicurazioniTipoPolizza);
            component.set('v.Index_num_mesi_assic_non_connessa',StringNumMesiAssic);    
        
            if(comodityCheck.COM_CRMflag_prod_sani_non_conn__c !== intervista.COM_Durata_Sanitarie__c){
               //alert('1');
                component.set('v.quezione',"Perfetto "+component.get("v.status")+" "+name+" , colgo allora l'occasione per farle un breve " +
                    "riepilogo delle caratteristiche"+NumAssicurazione+"che ha sottoscritto. In questo modo " +
                    "saprà come comportarsi se mai dovesse averne bisogno");


                component.set('v.quezione1','Un\' ultima domanda '+component.get("v.status")+' '+name+':si ritiene soddisfatto delle modalità di proposizione'+
                    ' e vendita della copertura assicurativa facoltativa?');

                // component.set('v.isShown',false);
               
                // component.set('v.showButton',true);
            }
            else {
                //alert('2');
                /*
                component.set('v.assicurativoPerche',true);
                component.set('v.isShownSottoscirtta',false);
                component.set('v.assicurativoTracciaturaRecesso',false);
                component.set('v.isShownForNo',false); */
                  component.set('v.quezione',"Perfetto "+component.get("v.status")+" "+name+" , colgo allora l'occasione per farle un breve " +
                    "riepilogo delle caratteristiche"+NumAssicurazione+" che ha sottoscritto. In questo modo " +
                    "saprà come comportarsi se mai dovesse averne bisogno");


                component.set('v.quezione1','Un\' ultima domanda '+component.get("v.status")+' '+name+':si ritiene soddisfatto delle modalità di proposizione'+
                    ' e vendita della copertura assicurativa facoltativa?');

             
            }

        },

	getDomandaProdottoNon: function (component, event, helper)
    {

        if(component.get('v.risposta'))
        {
            var risposte = component.get('v.risposta');
        }else{
            var risposte = component.get('v.rispondeQuezione');
        }
        console.log('Response', JSON.stringify(risposte));
        risposte.D3__c = "No/Non ricordo/Non ho sottoscritto nulla";
        console.log('response', risposte.D3__c);
        component.set('v.rispondeQuezione',risposte);
        component.set('v.risposta',risposte);
        console.log('Response', component.get('v.rispondeQuezione'));
        //----------------------------------------------------------------------------------//
        //component.set('v.isShown',false)
         component.set('v.assicurativoPerche',false);
        //component.set('v.isShownSottoscirtta',true);
         component.set('v.assicurativoTracciaturaRecesso',true); 
        //component.set('v.showButton',true);
        component.set('v.isShownForNo',true);
        //component.set('v.isShownSottoscirtta',false);
        
        
         component.set('v.quezione','');
        
         var FlagNonConn = component.get('v.indexFlag');
         if( FlagNonConn == true )
         {
            component.set('v.isShownSottoscirtta',true);
         }
        
          var comodityCheck     = component.get('v.comodityCheklist');
              comodityCheck     = comodityCheck.filter(
                                              row =>
                                              row.COM_CRMflag_prod_sani_non_conn__c === "S" );
        
          if( comodityCheck.length > 1 )
          {
              component.set('v.Frase_SP_1',' si ricorda che le polizze denominate ');
              component.set('v.Frase_SP_2',' da Lei sottoscritte, hanno una durata pari a ');
          }else{
              component.set('v.Frase_SP_1',' si ricorda che la polizza denominata ');
              component.set('v.Frase_SP_2',' da Lei sottoscritta, ha una durata pari a ');
          }
       
          var StringAssicurazioniTipoPolizza = ' '; 
          var StringNumMesiAssic             = ' ';
        
            //var NumAssicurazione  = component.get("v.NumeroAssicurazioneStr1");
            for( var i = 0 ; i < comodityCheck.length ; i ++ )
            {
                 if( comodityCheck.length == 1 )
                     {
                         StringAssicurazioniTipoPolizza  = StringAssicurazioniTipoPolizza+comodityCheck[i].COM_CRMTipo__c;
                         StringNumMesiAssic              = StringNumMesiAssic+comodityCheck[i].COM_CRMCalcolo_giorni_recesso__c;
                         console.log('--01--');
                     }else{
                         console.log('comodityCheck.length:'+comodityCheck.length);
                         if( i == (comodityCheck.length - 1) )
                         {
                         StringAssicurazioniTipoPolizza  = StringAssicurazioniTipoPolizza+comodityCheck[i].COM_CRMTipo__c;
                         StringNumMesiAssic              = StringNumMesiAssic+comodityCheck[i].COM_CRMCalcolo_giorni_recesso__c;
                         console.log('--02--');
                         }else{
                         StringAssicurazioniTipoPolizza  = StringAssicurazioniTipoPolizza+comodityCheck[i].COM_CRMTipo__c+',';
                         StringNumMesiAssic              = StringNumMesiAssic+comodityCheck[i].COM_CRMCalcolo_giorni_recesso__c+',';
                         console.log('--03--');
                         }
                     }
            }
            component.set('v.stringAssicurazione',StringAssicurazioniTipoPolizza);
            component.set('v.Index_num_mesi_assic_non_connessa',StringNumMesiAssic);    
        
        
    },
    
    AppuntamentoFissatoSi: function(component){

        if(component.get('v.risposta')){

            var risposte = component.get('v.risposta');
        }else{

            var risposte = component.get('v.rispondeQuezione');
        }

        console.log('Response', JSON.stringify(risposte));
        risposte.D4__c = "Si";
        console.log('response', risposte.D4__c);
        component.set('v.rispondeQuezione',risposte);
        component.set('v.risposta',risposte);
        console.log('Response', component.get('v.rispondeQuezione'));
        //-------------------------------------------------------------------------------------------//
        component.set('v.AppuntamentoFissato','Si');
        component.set('v.showButton',true);
        component.set('v.cancella',true);
    },


    AppuntamentoFissatoNon: function(component){

        if(component.get('v.risposta')){

            var risposte = component.get('v.risposta');
        }else{

            var risposte = component.get('v.rispondeQuezione');
        }

        console.log('Response', JSON.stringify(risposte));
        risposte.D4__c = "No";
        console.log('response', risposte.D4__c);
        component.set('v.rispondeQuezione',risposte);
        component.set('v.risposta',risposte);
        console.log('Response', component.get('v.rispondeQuezione'));
        //-------------------------------------------------------------------------------------------//
        component.set('v.AppuntamentoFissato','Non');
        component.set('v.showButton',true);
        component.set('v.cancella',true);
    },

    
    getDomandaProdottosottoscirttaSi: function(component){
        // var risposta = component.get('v.risposta');
        // risposta.D5__c = 'Si';
        // component.set('v.risposta',risposta);
        if(component.get('v.risposta')){

            var risposte = component.get('v.risposta');
        }else{

            var risposte = component.get('v.rispondeQuezione');
        }

        console.log('Response', JSON.stringify(risposte));
        risposte.D5__c = "Si";
        console.log('response', risposte.D5__c);
        component.set('v.rispondeQuezione',risposte);
        component.set('v.risposta',risposte);
        console.log('Response', component.get('v.rispondeQuezione'));
        //-------------------------------------------------------------------------------------------//
        component.set('v.AppuntamentoFissato','Non');
        component.set('v.showButton',true);
        component.set('v.cancella',true);
    },
    
    getDomandaProdottosottoscirttaNon: function(component){
        // var risposta = component.get('v.risposta');
        // risposta.D5__c = 'Non';
        // component.set('v.risposta',risposta);
        if(component.get('v.risposta')){

            var risposte = component.get('v.risposta');
        }else{

            var risposte = component.get('v.rispondeQuezione');
        }

        console.log('Response', JSON.stringify(risposte));
        risposte.D5__c = "Si";
        console.log('response', risposte.D5__c);
        component.set('v.rispondeQuezione',risposte);
        component.set('v.risposta',risposte);
        console.log('Response', component.get('v.rispondeQuezione'));
        //-------------------------------------------------------------------------------------------//
        component.set('v.AppuntamentoFissato','Non');
        component.set('v.showButton',true);
        component.set('v.cancella',true);
    },

    /**
     * @description: method for save satate to Conclusa
     * @author:Mamadou Lamine CAMARA
     *
     * @params: component, event, helper
     * @return: none
     * @modification:
     */
    /*concludi: function (component, event, helper)
    {
           var risposte = component.get('v.risposta');
           console.log('Response', JSON.stringify(risposte));

           var intervista=component.get('v.nuovaIntervista');
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
          $A.enqueueAction(action1);

          // helper.saveRisposta(component, risposte, intervista.Id);
          component.set('v.showButton',false);
          component.set('v.isRispostaExist',true);
          component.set('v.disponibileNonAdesso',false);
          component.set('v.isShownForNo',false);
          component.set('v.assicurativoPerche',false);
        },
        */
    /**
     * @description: method for save satate to redirect to Appuntamento
     * @author:Mamadou Lamine CAMARA
     *
     * @params: component, event, helper
     * @return: none
     * @modification:
     */
    redirect: function (component,event,helper) {
        console.log('devo aprire il modale');
        component.set("v.FissaAppuntamentoFlag",true);
        /*
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
        
        /*
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:creaAppuntamento",
        });
        evt.fire();
               /*
        component.set('v.disponibileNonAdesso',true);
        component.set('v.cancella',false);
        var intervista = component.get('v.nuovaIntervista');
        var dateIlSrting = helper.convertDateBeforeToString(intervista.COM_Data_Scadenza_Recesso__c,1);
        component.set('v.quezione','Chiedere quando è possibilie richiamare e fissare ricontatto entro il '+dateIlSrting+' ?');
        */
    },

    closeModal : function ( component,event,helper )
    {
        component.set("v.FissaAppuntamentoFlag",false);
    }



})