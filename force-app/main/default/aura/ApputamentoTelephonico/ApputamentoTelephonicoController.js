({
    salvareAppuntamento: function (component, event, helper) 
    {
        var dateAppuntamento = component.find('idDate').get('v.value');
        var NoteAppuntamento = component.find('idtelephonicoNote').get('v.value');
        console.log('NoteAppuntamento:'+NoteAppuntamento);
        console.log('dateAppuntamento:'+dateAppuntamento);
        /**** Check Required value ****/
        if( ( dateAppuntamento === undefined || dateAppuntamento === '' ) ||
            ( NoteAppuntamento === undefined || NoteAppuntamento === '' ) )
        {
            helper.showToast('Indicare la data e riempire il campo note!','error');
            return;
        }
        
        var intervista       = component.get('v.nuovaIntervista');
        var FlowFissaApp     = component.get('v.ParentAttributeOfChild3');
        console.log('intervista', JSON.stringify(intervista));
        //alert('24_05_2019 FlowFissaApp->'+FlowFissaApp);return;

        //Caso non risponde
        if( FlowFissaApp === true )
        {
            //alert('1');
            //alert('intervista.COM_count_non_risp__c -->'+intervista.COM_count_non_risp__c);
            if( ( intervista.COM_count_non_risp__c !== undefined && intervista.COM_count_non_risp__c === 5 )
                 )
            {
                //alert('2');
                intervista.COM_Stato_Avanzamento_Intervista__c = 'Conclusa'
                intervista.COM_Status__c                       = 'Archived';
                intervista.COM_Data_Esito__c                   = new Date();
            }else if ( ( intervista.COM_count_non_risp__c !== undefined && intervista.COM_count_non_risp__c < 5 )
                      || intervista.COM_count_non_risp__c === undefined )
            {
                //alert('3');
                intervista.COM_Stato_Avanzamento_Intervista__c = 'Non Risponde';
                intervista.COM_Status__c                       = 'New';   
                intervista.COM_Data_Esito__c                   = new Date();
                
                if( intervista.COM_count_non_risp__c === undefined )
                {
                    intervista.COM_count_non_risp__c = 1;
                    //alert('27_05_2019 intervista.COM_count_non_risp__c --> '+intervista.COM_count_non_risp__c );

                }else{
                    intervista.COM_count_non_risp__c = intervista.COM_count_non_risp__c + 1 ;//++;//               = 1;
                }
            
                intervista.COM_CRMRichiamare_il__c             = dateAppuntamento;
                intervista.COM_callback_notes__c               = NoteAppuntamento;
                intervista.COM_interview_accepted__c           = false;
                intervista.COM_Intervista_Accettata__c         = 'NO';
                intervista.COM_Intervista_Utile__c             = 'NO';
                intervista.COM_Intervista_Non_Utile__c         = true;
                intervista.COM_Interview_Utils__c              = false;
            }

        }else if( FlowFissaApp === false )
        {
            intervista.COM_Stato_Avanzamento_Intervista__c = 'Richiamare';
            intervista.COM_Status__c                       = 'New';
            intervista.COM_Data_Esito__c                   = new Date();
            intervista.COM_CRMRichiamare_il__c             = dateAppuntamento;
            intervista.COM_callback_notes__c               = NoteAppuntamento;
            
            if( intervista.COM_count_richiama__c === undefined )
            {
                intervista.COM_count_richiama__c = 1;   
            }else{
                intervista.COM_count_richiama__c = intervista.COM_count_richiama__c +1;//++;
            }
            
            
             intervista.COM_interview_accepted__c           = false;
                intervista.COM_Intervista_Accettata__c         = 'NO';
              
        }
        
        console.log('intervistaAppunt', JSON.stringify(intervista));
        var action = component.get('c.updateIntervista');
            action.setParam('param',intervista);
            action.setCallback(this, function (response) 
            {
                  var state = response.getState();
                  if ( state === 'SUCCESS' ) 
                  {
                     component.set('v.nuovaIntervista', response.getReturnValue());
                     console.log('in success',response.getReturnValue());
                     var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
                         eventRefreshIntervista.fire()
                     /*
                     helper.showToast('Salvataggio con successo!', 'SUCCESS');
                     component.set('v.ParentAttributeOfChild1', false );*/
                  }else{
                     helper.showToast('Salvataggio non effettuato!', 'ERROR');
                  }
            });
            $A.enqueueAction(action);
    },
    NonInteressato: function ( component , event , helper )
    {
        var intervista = component.get('v.nuovaIntervista');
        console.log('intervista', JSON.stringify(intervista));
        
        //intervista.COM_CRMRichiamare_il__c = dateAppuntamento;
        intervista.COM_Stato_Avanzamento_Intervista__c = 'Non accetta';
        intervista.COM_Status__c                       = 'Archived';
        intervista.COM_interview_accepted__c           = false;
        intervista.COM_Intervista_Accettata__c         = 'NO';
        console.log('intervistaAppunt', JSON.stringify(intervista));
        var action = component.get('c.updateIntervista');
        action.setParam('param',intervista);
        action.setCallback(this, function (response) 
        {
               var state = response.getState();
               if (state === 'SUCCESS') 
               {
                   component.set('v.nuovaIntervista', response.getReturnValue());
                   console.log('in success',response.getReturnValue());
                   var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
                         eventRefreshIntervista.fire()
                   /*
                   helper.showToast('Salvataggio con successo!', 'SUCCESS');
                   component.set('v.ParentAttributeOfChild1', false );*/
               }else{
                   helper.showToast('Salvataggio non effettuato!', 'ERROR');
            }
        });
        $A.enqueueAction(action);
        /*
        component.set('v.nuovaIntervista',{
                'sobjectype': 'COM_Intervista__c',
                'COM_Stato_Avanzamento_Intervista__c': ''
            });
            //refresh detaghi intervista
                 var eventRefreshIntervista = $A.get("e.c:eventNavigateToIntervistaRisposteComp");
                    eventRefreshIntervista.fire();*/

   
    },
    Cancella: function( component , event , helper )
    {
        component.set('v.ParentAttributeOfChild', true );   
        component.set('v.ParentAttributeOfChild1', false );
         component.set('v.ParentAttributeOfChild2', false );
    },
    redirect: function (component, event, helper) {

        var eventGoFiliali = $A.get("e.c:eventGetIntervista");
        eventGoFiliali.fire();
    },
    showSpinner: function (component, event, helper) {
        component.set("v.toggleSpinner", true);
    },
    hideSpinner: function (component, event, helper) {
        component.set("v.toggleSpinner", false);
    },
    checkDate: function (component, event, helper) {
        var target = event.getSource();
       // if (!$A.util.isUndefinedOrNull(target)) { 
        try {
            var enteredValue = target.get("v.value");
            enteredValue = Date.parse(enteredValue);
            var g = new Date();
            g = g.setMinutes(g.getMinutes() + 10 );
            if ( enteredValue < g ) {
                helper.showToast(
                  "L'appuntamento deve essere fissato dopo l'ora attuale",
                  "ERROR"
                );
                component.set("v.showSave",true);

            } else {
                component.set("v.showSave",false);
            }
            // }
        } catch (e) {
            console.error('error '+ e);
        }
    }
})