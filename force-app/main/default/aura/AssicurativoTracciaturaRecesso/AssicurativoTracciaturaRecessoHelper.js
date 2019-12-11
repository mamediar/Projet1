/**
 * Created by Mamamdou Lamine on 10/04/2019.
 */
({
    /**
     * @description : To show Toast
     * @author: Mamadou Lamine CAMARA
     * @date: 10/04/2019
     * @param message
     * @param type
     */
    showToast : function(message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type : type
        });
        toastEvent.fire();
    },
    concludi: function(component){
        var NoteTracciaturaRec = component.get("v.Note");
		var risposte = component.get('v.risposta');
		var Note = component.get('v.Note');
		console.log('Response', JSON.stringify(risposte));
        
        //alert('21_05_2019 risposte'+risposte+'-Note-'+Note);

		var intervista = component.get('v.nuovaIntervista');
		intervista.COM_Stato_Avanzamento_IntervistaASS__c = 'Conclusa';
		intervista.COM_Status_ASS__c = 'Archived';
		intervista.COM_interview_accepted__c = true;
		intervista.COM_Intervista_Accettata__c = 'SI';
		intervista.COM_Data_Esito_ASS__c = new Date();
        var Provenienza              = intervista.COM_Provenienza__c;
        //alert('Provenienza->'+Provenienza);

		var action = component.get('c.updateIntervista');
		    action.setParam('param', intervista);
		    action.setCallback(this, function (response) 
            {
			       var state = response.getState();
			       if(state === 'SUCCESS')
                   {
				      component.set('v.nuovaIntervista', response.getReturnValue());
				      component.set('v.nonRisposta', false);
                   }else{
				      this.showToast('Salvataggio non successo', 'ERROR');
			       }
		    });
		$A.enqueueAction(action);

		risposte.Intervista__c                      = intervista.Id;
        risposte.Name                               = intervista.Name;
        risposte.COM_Note_Motivazione_Recesso__c    = NoteTracciaturaRec;//"Note";
		console.log('risposte', risposte);
		console.log('Intervista Id', intervista.Id);
		var action1 = component.get("c.addResponseAssicurativo");
		action1.setParams({
			"respdomanda": risposte
		});
		action1.setCallback(this, function (response) 
        {
			var state = response.getState();
			if(state === "SUCCESS")
            {
				this.showToast('Salvataggio Risposta con successo!', 'SUCCESS');
                if( Provenienza !== null && Provenienza !== undefined )
                {
                    if( Provenienza === 'A' )
                    { 
                          var eventGoFiliali = $A.get("e.c:eventNavigationAssicurativoPratiche");
				              eventGoFiliali.fire();
                    }else if ( Provenienza === 'F' )
                    {
                          var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
                              eventRefreshIntervista.fire(); 
                    }
                }
             	
			}else{
				var errors = response.getError();
				if(errors) 
                {
					if (errors[0] && errors[0].message) 
                    {
						console.log("Error message: " + errors[0].message);
					}
				}else{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action1);
	},
    
    checkFlusso1: function( component , event )
    {
        //Check Flusso
        var FlussoDomanda = component.get("v.FlussoDomanda");
        //alert('21_06_2019 FlussoDomanda:::>>>'+FlussoDomanda);
        var UltimaDomandaChecked = component.get("v.UltimaDomanda");
        var primaDomanda         = component.get("v.PrimaDomanda");
        var RecessoDomandaNo     = component.get("v.RecessoDomandaNo");
        var RecessoDomandaSi     = component.get("v.RecessoDomandaSi");
        var RecessoRispostaN     = component.get("v.RecessoRispostaNote");
        
        if( FlussoDomanda == "1" || FlussoDomanda == "2" || FlussoDomanda == "3" )
        {
             if( ( UltimaDomandaChecked == true && ( primaDomanda == true || primaDomanda == false ) ) 
              && ( RecessoDomandaNo == true || 
                                               ( RecessoDomandaSi == true && RecessoRispostaN == true)
                 )
               )
             {
                  component.set('v.showButton', true);
             }
        }
       
    }

})