({
    NonInteressato: function ( component , event , helper )
    {
        var intervista = component.get('v.nuovaIntervista');
        console.log('intervista', JSON.stringify(intervista));

        //intervista.COM_CRMRichiamare_il__c = dateAppuntamento;
        intervista.COM_Stato_Avanzamento_IntervistaASS__c = 'Non accetta';
        intervista.COM_Data_Esito_ASS__c = new Date();
        console.log('intervistaAppunt', JSON.stringify(intervista));
        var action = component.get('c.updateIntervista');
        action.setParam('param',intervista);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.nuovaIntervista', response.getReturnValue());
                console.log('in success',response.getReturnValue());
                helper.showToast('Salvataggio con successo!', 'SUCCESS');
                 component.set('v.ParentAttributeOfChild1', false );

            } else {
                helper.showToast('Salvataggio non successo', 'ERROR');
            }
        });
        $A.enqueueAction(action);
        component.set('v.nuovaIntervista',{
                'sobjectype': 'COM_Intervista__c',
                'COM_Stato_Avanzamento_Intervista__c': ''
            });
            //refresh detaghi intervista
                 var eventRefreshIntervista = $A.get("e.c:eventNavigateToIntervistaRisposteComp");
                    eventRefreshIntervista.fire();


    },
    Cancella: function( component , event , helper )
    {
        component.set('v.ParentAttributeOfChild', true );
        component.set('v.ParentAttributeOfChild1', false );
         component.set('v.ParentAttributeOfChild2', false );
         component.set('v.disponibileNonAdesso', false );
    },

    redirect: function (component, event, helper) {

        var eventGoFiliali = $A.get("e.c:eventGetIntervista");
        eventGoFiliali.fire();
    },
    /**
     * @description: method for show spinner
     * @date::18/03/2019
     * @author:Salimata NGOM
     * @params: component, event, helper
     * @return: none
     * @modification:
     */
    showSpinner: function (component, event, helper) {
        component.set("v.toggleSpinner", true);
    },
    /**
     * @description: method for hide spinner
     * @date::18/03/2019
     * @author:Salimata NGOM
     * @params: component, event, helper
     * @return: none
     * @modification:
     */
    hideSpinner: function (component, event, helper) {
        component.set("v.toggleSpinner", false);
    },
    clickCreate: function(component, event, helper) {
        var validExpense = component.find('idDate').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validExpense){
            var date= component.get("v.userDate");
            var time=component.get("v.userTime");
            var charsDate = date.split('-');
            var charsTime = time.split(':');
            var dateTime= new Date(charsDate[0],(charsDate[1]-1),charsDate[2],charsTime[0],charsTime[1]);
            helper.checkDate(component,dateTime);
        }
    }
})