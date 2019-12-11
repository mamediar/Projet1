({
/**
* @description: method for get all Intervista Domande
* @date::13/03/2019
* @author:Salimata NGOM
* @params: component, event,helper
* @return: none
* @modification:
*/
  doInit: function(component, event, helper) {
           
           
          var IntervistaObj = component.get("v.nuovaIntervistaDomandeComp");
          console.log(IntervistaObj);
          if( IntervistaObj.COM_cin_z_calc__c === 'R' )
          {
              component.set("v.CINZ_Flag",true);
          }else if( IntervistaObj.COM_cin_z_calc__c === 'G' ){
                 console.log('-------------- GGGG   ');
                 var now         = new Date();
                 var CurrentDay  = now.getDate();
                 console.log('26_03_2019 CurrentDay:'+CurrentDay);
                 if( CurrentDay > 24 )
                 {
                      var LimitCIN_Z     = '';
                      var NumeroMAXCIN_Z = '';
                      var actionJS       = component.get('c.getLimitCINZFromCS');
                      var actionJS1      = component.get('c.getCountIntervisteCINZ_G');
                          /*
                          actionJS1.setParams({
                                                "AccountId":IntervistaObj.COM_Filiale__c
                                              });*/
                      actionJS.setCallback( this, function(response) 
                      {
                          var state = response.getState();
                          if (state === "SUCCESS") 
                          {
                              var ResponseValue = response.getReturnValue();
                              LimitCIN_Z = ResponseValue;
                              console.log( '26_03_2019 ResponseValue: '+ResponseValue+LimitCIN_Z);
                          }
                      });
                      $A.enqueueAction( actionJS );
                      actionJS1.setCallback( this, function(response) 
                      {
                          var state = response.getState();
                          if (state === "SUCCESS") 
                          {
                              var ResponseValue = response.getReturnValue();
                              NumeroMAXCIN_Z = ResponseValue;
                              console.log( '26_03_2019 ResponseValue: '+ResponseValue+NumeroMAXCIN_Z);
                          }
                      });
                      $A.enqueueAction( actionJS1 );
                      console.log('26_03_2019 LimitCIN_Z: '+LimitCIN_Z+'///NumeroMAXCIN_Z:'+NumeroMAXCIN_Z);
                      if( NumeroMAXCIN_Z < LimitCIN_Z )
                      {
                          component.set("v.CINZ_Flag",true);
                      }
                      
                 }
              
          }
          helper.fetchTypePicklist(component);
          //call apex class method
          console.log('---step1---');
          component.set('v.Domanda1',"A seguito della sottoscrizione,mi conferma che le è stato consegnato il contratto?");
          component.set('v.Domanda2',"Prima di stipulare il contratto,mi conferma che le è  stato consegnato il documento 'Informazioni Europee di Base sul Credito ai Consumatori'?( Se il cliente chiede maggiori informazioni: il modulo 'informazioni Europee di Base sul credito ai consumatori' è un documento informativo che contiene alcuni dati del cliente e tutte le condizioni economiche formulate dal Finanziatore sulla base delle esigenze Finanziarie espresse in fase precontrattuale dal cliente stesso. Tale documento non produce effetti obbligatori fra le parti).");
          component.set('v.Domanda3',"Prima di stipulare il contratto, poteva richiedere la copia contrattuale idonea per la stipula.L'ha richiesta, le è stata rilasciata?( Se il cliente chiede maggiori informazioni: la copia contrattuale idonea per stipula è una copia completa del testo contrattuale, che il cliente può facoltativamente richiedere prima di sottoscrivere il contratto)");
          component.set('v.Domanda4',"Con riferimento alla/e coperture assicurative a cui lei ha aderito, Le è stata consegnato il/i questionario/i per la valutazione dell' adeguatezza del/i contratto/i assicurativo/i ? ( Se il cliente chiede maggiori informazioni: il questionario è un documento che mira ad acquisire le informazioni al fine di proporre al cliente un contratto adeguato alle proprie esigenze assicurative )");
          component.set('v.Domanda5',"Con riferimento alla/e coperture assicurative a cui lei ha aderito,mi conferma che Le è stato consegnato apposito e separato contratto di adesione?");
          component.set('v.Domanda6', "Con riferimento alla/e copertura/e assicurativa/e ha sottoscritto, mi conferma che Le è stata consegnata la relativa documentazione assicurativa? ( Se il cliente chiede maggiori informazioni: vi è obbligo , in caso di adesione alla copertura, di consegnare le condizioni di polizza e l' informativa precontrattuale, che contiene gli strumenti di tutela riservati al cliente e gli elementi identificativi di Compass, della compagnia assicurativa e del soggetto proponente");
          component.set('v.Domanda7',"Infine, ritiene che il collega di Filiale sia stato chiaro e completo nel fornirle le informazioni sul prodotto scelto e nel rispondere a sue eventuali domande ?");
          
      
          var action = component.get('c.getRisposta');
              action.setParams({
                               'idIntervista': IntervistaObj.Id
                              });
       
          action.setCallback(this, function(response) {
             //store state of response
             var state = response.getState();
             if (state === "SUCCESS") 
             {
                var RispostaObj = response.getReturnValue();
                component.set('v.Note1', RispostaObj.COM_Note_Contratto__c);
                component.set('v.Note2', RispostaObj.COM_Note_Secci__c);
                component.set('v.Note3', RispostaObj.COM_Note_Precontratto__c);
                component.set('v.Note4', RispostaObj.COM_Note_Soddisfazione_Cliente__c);


                //set response value in paginationList attribute on component.
                console.log('---step2---');
                component.set('v.listDomande', response.getReturnValue());
                console.log('---step3---');
             }
          });
          $A.enqueueAction(action);

       },
/**
* @description: method for save all response
* @date::14/03/2019
* @author:Salimata NGOM
* @params: component, event, helper
* @return: void
* @modification:
*/
   salvareDomande: function (component, event, helper){

       //fire event for set spinner to true
        //var evt = $A.get("e.c:eventShowSpinnerDomanda")
       // evt.fire();
        var select = document.getElementById("domanda1");
        var Contratto = select.options[select.selectedIndex].value;
        select = document.getElementById("domanda2");
        var Secci = select.options[select.selectedIndex].value;
        select = document.getElementById("domanda3");
        var Precontratto = select.options[select.selectedIndex].value;
        /*select = document.getElementById("domanda4");
        var Questionario_assicurativo = select.options[select.selectedIndex].value;
        select = document.getElementById("domanda5");
        var Contratto_Assicurazione = select.options[select.selectedIndex].value;
        select = document.getElementById("domanda6");
        var Documenti_Assicurazione = select.options[select.selectedIndex].value;*/
        var select = document.getElementById("domanda7");
        var Soddisfazione_Cliente= select.options[select.selectedIndex].value;
       
       
        //Get Notes
        var NoteContratto                   = component.find('NomeDomanda1').get('v.value');
        var NoteSecci                       = component.find('NomeDomanda2').get('v.value');
        var NotePrecontratto                = component.find('NomeDomanda3').get('v.value');
        var NoteSoddisfazioneCliente        = component.find('NomeDomanda4').get('v.value');
    

        var Count_Positivi = 0;
        var Count_Negativi = 0;

        var listRes = [];
        listRes.push(Contratto);
        listRes.push(Secci);
        listRes.push(Precontratto);
        //listRes.push(Questionario_assicurativo);
        //listRes.push(Contratto_Assicurazione);
        //listRes.push(Documenti_Assicurazione);
        listRes.push(Soddisfazione_Cliente);

         //check if values are empty
        var BooleanCheckQuestionRequired = helper.checkifEmpty(listRes);
        if (/*helper.checkifEmpty(listRes)*/ BooleanCheckQuestionRequired === true) {
            helper.showToast('Errore: Tutte le domande presentate hanno obbligo di risposta, e solo completata l’intervista sarà possibile premere “Concludi intervista” o “Continua intervista Assicurativo” ', 'ERROR');
            return;
        }

        listRes.forEach(function (value, index) 
        {
           if( value=='Si' || value=='No' )
           {
              if( value=='Si' )
              {
                 Count_Positivi++;
              }else{
                 Count_Negativi++;
             }
          }
        })
        var risposte = new Object();
        if(component.get('v.risposta'))
        {
           risposte = component.get('v.risposta');
        }else{
           risposte = component.get('v.rispondeQuezione');
        }
        console.log('Risposta',risposte);
        console.log(' Contratto ',Contratto);
        risposte.Contratto1__c=Contratto;
        risposte.Secci1__c=Secci;
        risposte.Precontratto1__c=Precontratto;
        //risposte.Questionario_assicurativo1__c='Non valutabile';//Questionario_assicurativo;
        //risposte.Contratto_Assicurazione__c='Non valutabile';//Contratto_Assicurazione;
        //risposte.Documenti_Assicurazione1__c='Non valutabile';//Documenti_Assicurazione;
        risposte.Soddisfazione_Cliente1__c=Soddisfazione_Cliente;
        //risposte.Count_Negativi__c=Count_Negativi;
        //risposte.Count_Positivi__c=Count_Positivi;
         
        var DomandaAggiuntivaBoolean = component.get("v.RenderFilialiPostaQuestion");
        console.log('16_04_ DomandaAggiuntivaBoolean::::' + DomandaAggiuntivaBoolean);

        //alert('DomandaAggiuntivaBoolean->'+DomandaAggiuntivaBoolean);
        if (DomandaAggiuntivaBoolean === true) {
            var ValoreFilialePosta = document.getElementById("domanda8");
            var SelectValoreFilialePosta = ValoreFilialePosta.options[ValoreFilialePosta.selectedIndex].value;
            //alert('SelectValoreFilialePosta->'+SelectValoreFilialePosta);
            if( SelectValoreFilialePosta === '--Selezionare--' )
            {
                helper.showToast('Completare l\'intervista selezionando la domanda aggiuntiva ', 'ERROR');
                return;
            }
            console.log('16_04_ SelectValoreFilialePosta::::' + SelectValoreFilialePosta);
            risposte.COM_Filiale_Posta__c = SelectValoreFilialePosta;
        }
       
        //Storage Notes
        risposte.COM_Note_Contratto__c                  = NoteContratto;
        risposte.COM_Note_Secci__c                      = NoteSecci;
        risposte.COM_Note_Precontratto__c               = NotePrecontratto;
        risposte.COM_Note_Soddisfazione_Cliente__c      = NoteSoddisfazioneCliente;
       
        risposte.COM_Note_Questionario_Assicurativo__c  = 'Non valutabile';
        risposte.COM_Note_Contratto_Assicurazione__c    = 'Non valutabile';
        risposte.COM_Note_Documenti_Assicurazione__c    = 'Non valutabile';
      

       
        /** @@ Modified by Orlando 16_03_2019 **/
        var IntervistaObj     = component.get('v.nuovaIntervista');
        IntervistaObj.COM_Stato_Avanzamento_Intervista__c = 'Conclusa';
        IntervistaObj.COM_Status__c                       = 'Archived';
        IntervistaObj.COM_Data_Esito__c                   = new Date();
        risposte.Intervista__c= IntervistaObj.Id;//component.get('v.nuovaIntervista');

        /***************************************/

        console.log('riposte=',JSON.stringify(risposte));
        var risposteParam = JSON.stringify(risposte);
        var action2       = component.get('c.updateIntervista');
            action2.setParams({
                              "param":IntervistaObj
                              });
            action2.setCallback( this, function(response)
            {
                    var state = response.getState();
                    if ( state === "SUCCESS" ) 
                    {
                         console.log('success update',IntervistaObj);
                         component.set('v.nuovaIntervista',response.getReturnValue());
                    }
            });
            $A.enqueueAction(action2);
        var action = component.get('c.addResponse');
            action.setParams({
                    "respdomanda":risposte,
                    "IntervistaIstance":IntervistaObj,
                    "ProdottoEV":true,
                    "FilialePosta":DomandaAggiuntivaBoolean
                });
            action.setCallback( this, function(response)
            {
             //store state of response
             var state = response.getState();
             if ( state === "SUCCESS" ) 
             {
                  console.log('19-03.2019');
                  component.set('v.risposta', JSON.stringify(response.getReturnValue()));
                  var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
                         eventRefreshIntervista.fire();
                  /*
                  console.log('response.getReturnValue()'+ JSON.stringify(response.getReturnValue()));
                  var eventToRisposta=$A.get("e.c:eventNavigateToIntervistaRisposteComp");
                  eventToRisposta.setParams({'riposta':risposte});
                  eventToRisposta.fire();
                  helper.showToast('Salvataggio con successo!', 'SUCCESS');*/
             }
                else{
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
          $A.enqueueAction(action);
          component.set('v.rispondeQuezione',{'sobjectType':'Risposte__c',
                                             'Contratto1__c':'',
                                             'Secci1__c':'',
                                             'Precontratto1__c':'',
                                             'Questionario_assicurativo1__c':'',
                                             'Contratto_Assicurazione__c':'',
                                             'Documenti_Assicurazione1__c':'',
                                             'Soddisfazione_Cliente1__c':'',
                                             'Count_Negativi__c':'0',
                                             'Count_Positivi__c':'0',
                                             'Intervista__c':'',
                                             'Valutazione__c':''});
    },
   Cancella: function( component , event , helper )
   {
        console.log('ciao');
        var TipoOfDML     = component.get("v.TypeOfDML");
        console.log('16_04_2019 TipoOfDML::'+TipoOfDML);
        if( TipoOfDML === 'INSERT' )
        {
            component.set('v.ParentAttributeOfChild', true );
            component.set('v.ParentAttributeOfChild1', false );
        }else if( TipoOfDML === 'UPDATE' )
        {
            component.set( 'v.UpdateResponse',false );
            component.set('v.isRispostaEx', true );
        }
   },
   ContinuaIntervistaAssicurativo: function( component , event , helper )
   {
        var IntervistaObj = component.get("v.nuovaIntervistaDomandeComp");
        
        //Check Domande
        var BooleanCheckDomCompilate     = helper.checkDomandeCompilate(component,event);
        var BooleanCheckDomAggiuntiva    = helper.checkDomandaAggiuntivaObbligatoria(component,event);
        var DomandaAggiuntivaBoolean = component.get("v.RenderFilialiPostaQuestion");
       
        if( BooleanCheckDomCompilate     === true ) 
        {
            helper.showToast('Errore: Tutte le domande presentate hanno obbligo di risposta, e solo completata l’intervista sarà possibile premere “Concludi intervista” o “Continua intervista Assicurativo” ', 'ERROR');
            return;
        } 
        //Check Domanda Aggiuntiva
        if( BooleanCheckDomAggiuntiva    === true )
        {
            helper.showToast('Completare l\'intervista selezionando la domanda aggiuntiva ', 'ERROR');
            return;
        }
       
         var select                 = document.getElementById("domanda1");
         var Contratto              = select.options[select.selectedIndex].value;
         select                     = document.getElementById("domanda2");
         var Secci                  = select.options[select.selectedIndex].value;
         select                     = document.getElementById("domanda3");
         var Precontratto           = select.options[select.selectedIndex].value;
         var select                 = document.getElementById("domanda7");
         var Soddisfazione_Cliente  = select.options[select.selectedIndex].value;

         var NoteContratto                   = component.find('NomeDomanda1').get('v.value');
         var NoteSecci                       = component.find('NomeDomanda2').get('v.value');
         var NotePrecontratto                = component.find('NomeDomanda3').get('v.value');
         var NoteSoddisfazioneCliente        = component.find('NomeDomanda4').get('v.value');
    
         var Count_Positivi = 0;
         var Count_Negativi = 0;

         var listRes = [];
         listRes.push(Contratto);
         listRes.push(Secci);
         listRes.push(Precontratto);
         listRes.push(Soddisfazione_Cliente);

         listRes.forEach(function (value, index) 
         {
           if( value=='Si' || value=='No' )
           {
              if( value=='Si' )
              {
                 Count_Positivi++;
              }else{
                 Count_Negativi++;
             }
           }
         })
        
         var risposte = new Object();
         if(component.get('v.risposta'))
         {
            risposte = component.get('v.risposta');
         }else{
            risposte = component.get('v.rispondeQuezione');
         }
         console.log('Risposta',risposte);
         console.log(' Contratto ',Contratto);
         risposte.Contratto1__c=Contratto;
         risposte.Secci1__c=Secci;
         risposte.Precontratto1__c=Precontratto;
         risposte.Soddisfazione_Cliente1__c=Soddisfazione_Cliente;
         //risposte.Count_Negativi__c=Count_Negativi;
         //risposte.Count_Positivi__c=Count_Positivi;
       
         if(DomandaAggiuntivaBoolean === true) 
         {
            var ValoreFilialePosta = document.getElementById("domanda8");
            var SelectValoreFilialePosta = ValoreFilialePosta.options[ValoreFilialePosta.selectedIndex].value;
            if( SelectValoreFilialePosta === '--Selezionare--' )
            {
                helper.showToast('Completare l\'intervista selezionando la domanda aggiuntiva ', 'ERROR');
                return;
            }
            console.log('16_04_ SelectValoreFilialePosta::::' + SelectValoreFilialePosta);
            risposte.COM_Filiale_Posta__c = SelectValoreFilialePosta;
         }
         //Storage Notes
         risposte.COM_Note_Contratto__c                  = NoteContratto;
         risposte.COM_Note_Secci__c                      = NoteSecci;
         risposte.COM_Note_Precontratto__c               = NotePrecontratto;
         risposte.COM_Note_Soddisfazione_Cliente__c      = NoteSoddisfazioneCliente;
       
         risposte.COM_Note_Questionario_Assicurativo__c  = 'Non valutabile';
         risposte.COM_Note_Contratto_Assicurazione__c    = 'Non valutabile';
         risposte.COM_Note_Documenti_Assicurazione__c    = 'Non valutabile';
      
         /** @@ Modified by Orlando 16_03_2019 **/
         var IntervistaObj     = component.get('v.nuovaIntervista');
         IntervistaObj.COM_Provenienza__c = 'F';
         IntervistaObj.COM_Stato_Avanzamento_Intervista__c = 'Conclusa';
         IntervistaObj.COM_Status__c                       = 'Archived';
         IntervistaObj.COM_Data_Esito__c                   = new Date();
         IntervistaObj.COM_Intervista_Accettata__c = 'SI';
         IntervistaObj.COM_Intervista_Accettata__c = 'SI';
         IntervistaObj.COM_Provenienza__c = 'F';
         risposte.Intervista__c= IntervistaObj.Id;//component.get('v.nuovaIntervista');

         var action = component.get('c.updateIntervista');
             action.setParams({
                                'param': IntervistaObj
                               });
             action.setCallback(this, function (response) 
             {
                    var state = response.getState();
                    if (state === "SUCCESS") 
                    {
                        console.log('success update',IntervistaObj);
                        component.set('v.nuovaIntervista',response.getReturnValue());
                    }else{
                        console.log('error');
                    }
             });

          console.log('riposte=',JSON.stringify(risposte));
          /**************************** Aggiornamento Risposta ******************************/
          var action = component.get('c.addResponse');
              action.setParams({
                                 "respdomanda":risposte,
                                 "IntervistaIstance":IntervistaObj,
                                 "ProdottoEV":true,
                                 "FilialePosta":DomandaAggiuntivaBoolean
                               });
              action.setCallback( this, function(response)
              {
                   var state = response.getState();
                   if( state === "SUCCESS" ) 
                   {
                       //Diverse Casistiche di Reindirizzamento
                       // Se Assicurativo si trova in stato 'Processing' oppure 'Archived' 
                       // allora si reindirizza verso la Lista dei Clienti di tipo Filiale
                       /*
                       alert('21_05_2019 IntervistaObj->'+IntervistaObj.COM_Status_ASS__c);
                       if( IntervistaObj.COM_Status_ASS__c === 'Processing' || 
                           IntervistaObj.COM_Status_ASS__c === 'Archived' )
                       {
                        alert('----()');
                           var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
                               eventRefreshIntervista.fire();
                       }else 
                       */
                       if( IntervistaObj.COM_Status_ASS__c === 'New' || IntervistaObj.COM_Status_ASS__c === 'Processing')
                       {
                           //alert('----');
                           var evt = $A.get("e.c:eventNavigationAssicurativo");
                               evt.setParams({
                                               "Id": IntervistaObj.Id
                                             });
                               evt.fire();
                       }else{
                           var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
                               eventRefreshIntervista.fire(); 
                       }
                   }else{
                       var errors = response.getError();
                       if(errors) 
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
              $A.enqueueAction(action);
              component.set('v.rispondeQuezione',{'sobjectType':'Risposte__c',
                                                  'Contratto1__c':'',
                                                  'Secci1__c':'',
                                                  'Precontratto1__c':'',
                                                  'Questionario_assicurativo1__c':'',
                                                  'Contratto_Assicurazione__c':'',
                                                  'Documenti_Assicurazione1__c':'',
                                                  'Soddisfazione_Cliente1__c':'',
                                                  'Count_Negativi__c':'0',
                                                  'Count_Positivi__c':'0',
                                                  'Intervista__c':'',
                                                  'Valutazione__c':''});

       
    },
   OnChangeQuestion1: function (component, event, helper) 
   {
        var CheckBoolean = helper.checkDomandaAggiuntiva( component );
        if( CheckBoolean === true )
        {
            component.set("v.RenderFilialiPostaQuestion", true);
        }else{
            component.set("v.RenderFilialiPostaQuestion", false);
        }
   }
        
})