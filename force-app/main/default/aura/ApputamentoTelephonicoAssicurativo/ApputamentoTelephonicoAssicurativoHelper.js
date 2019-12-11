({
    salvareAppuntamento: function (component,dateAppuntamento) 
    {
      
        var NoteAppuntamento=component.get("v.note");
        console.log('NoteAppuntamento:'+NoteAppuntamento);
        console.log('dateAppuntamento:'+dateAppuntamento);
        /**** Check Required value ****/
       /* if( ( dateAppuntamento === undefined || dateAppuntamento === '' ) ||
           ( NoteAppuntamento === undefined || NoteAppuntamento === '' ) )
        {
            helper.showToast('Indicare la data e riempire il campo note!','error');
        }*/
        component.set('v.disponibileNonAdesso',false);

        var intervista = component.get('v.nuovaIntervista');
        console.log('intervista', JSON.stringify(intervista));

        intervista.COM_CRMRichiamare_ilASS__c                 = dateAppuntamento;
        intervista.COM_Stato_Avanzamento_IntervistaASS__c     = 'Richiamare';
        intervista.COM_Data_Esito_ASS__c                      = new Date();
        intervista.COM_callbackASS_notes__c                   = NoteAppuntamento;
        intervista.COM_Status_ASS__c                          = 'New';
        
        if( intervista.COM_count_richiamaASS__c === undefined || intervista.COM_count_richiamaASS__c === NaN )
        {
            intervista.COM_count_richiamaASS__c = 1;
            //alert('27_05_2019 intervista.COM_count_richiamaASS__c->'+intervista.COM_count_richiamaASS__c);
        }else{
            intervista.COM_count_richiamaASS__c = intervista.COM_count_richiamaASS__c +1 ;//component.get("v.numNonRispondeAppTelAss");
            //alert('27_05_2019 intervista.COM_count_richiamaASS__c->'+intervista.COM_count_richiamaASS__c);
        }
        //intervista.COM_Data_Esito__c                      = new Date();
        console.log('intervistaAppunt', JSON.stringify(intervista));
        var action = component.get('c.updateIntervista');
        action.setParam('param',intervista);
        action.setCallback(this, function (response) 
        {
            var state = response.getState();
            if ( state === 'SUCCESS' ) 
            {
                component.set('v.nuovaIntervista', response.getReturnValue());
                 var eventGoFiliali = $A.get("e.c:eventNavigationAssicurativoPratiche");
                eventGoFiliali.fire();
                console.log('in success',response.getReturnValue());
                this.showToast('Salvataggio con successo!', 'SUCCESS');
                component.set('v.ParentAttributeOfChild1', false );
            }else{
                this.showToast('Salvataggio non effettuato!', 'ERROR');
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
                    eventRefreshIntervista.fire(); */

    },
	showToast : function(message, type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type : type
		});
		toastEvent.fire();
	},
	checkDate : function(component,myDate){
		try {
            var enteredValue = Date.parse(myDate) / 60000;
            var g = new Date();
            var valueDate = Date.parse(g) / 60000;
            var currentMns = Math.floor(valueDate);
            //alert(currentMns);
            //alert(valueDate);
            //g = g.setMinutes(g.getMinutes() + 40 );
            //alert('20_05_2019 g->'+g);
            //alert('20_05_2019 enteredValue->'+enteredValue);
            if (enteredValue < currentMns) {
              this.showToast(
                "L'appuntamento deve essere fissato dopo l'ora attuale",
                "ERROR"
              );
              component.set("v.showSave", true);
            } else {
              this.salvareAppuntamento(component,myDate);
            }
            // }
        } catch (e) {
            console.error('error '+ e);
        }
	}
})