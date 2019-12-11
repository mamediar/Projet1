({
    /**
    * @description: method for get Intervista Dettaghi
    * @date::12/03/2019
    * @author:Salimata NGOM
    * @params: component, event
    * @return: none
    * @modification:
    */
    getIntervistaDettagli: function (component, event) {

        var idintervista = component.get("v.Id");
        var data=component.get("v.dataList"); 
        console.log('idintervista' + idintervista);
        //call apex class method
        var action = component.get('c.getDettagliIntervista');
        // pass the apex method parameters to action
        action.setParams({
            'idintervista': idintervista
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var ResponseObj = response.getReturnValue();
                component.set('v.nuovaIntervista', ResponseObj)
                if (ResponseObj.COM_Stato_Avanzamento_Intervista__c === 'Richiamare' ||
                    ResponseObj.COM_Stato_Avanzamento_Intervista__c === 'Non Risponde') {
                    component.set('v.Richiamare', true);
                    //component.set('v.Nuova', false);
                    component.set('v.Nuova',true);
                } else if (ResponseObj.COM_Stato_Avanzamento_Intervista__c === 'Non accetta') {
                    component.set('v.NonAccetta', true);
                    component.set('v.Nuova', false);
                } else if (ResponseObj.COM_Stato_Avanzamento_Intervista__c === 'Conclusa') {
                    component.set('v.Conclusa', true);
                    component.set('v.Nuova', false);
                }
                //Check if product = 'EV' or not
                if (ResponseObj.COM_C_prod__c === 'EV') {
                    component.set('v.ProductTypeEV', true);
                }



                //alert('result'+JSON.stringify(response.getReturnValue()));
            } else {
                console.log('error');
            }
        });
        $A.enqueueAction(action);
        //check if risposta of intervista exist
        var action2 = component.get('c.getRisposta');
        action2.setParams({ 'idIntervista': idintervista });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.risposta', response.getReturnValue());
                console.log('--27_03_2019 ' + response.getReturnValue());
                if (component.get('v.risposta') != null) {
                    component.set('v.nonRisposta', false);
                    component.set('v.isRispostaExist', true);
                    component.set("v.toggleSpinner", false);
                    component.set("v.SpinnerSearch", false);
                }
            }
        });
        $A.enqueueAction(action2);
        //Check if the current User have Profile CC&Commodity or not
        var action3 = component.get('c.getUserInfos');
        action3.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('15_04_2019 response.getReturnValue()::::' + response.getReturnValue());
                component.set('v.ButtonModificaFlag', response.getReturnValue());
            }
        });
        $A.enqueueAction(action3);
    },
    /**
    * @description: method go back to list Pratiche
    * @date::12/03/2019
    * @author:Salimata NGOM
    * @params: component, event, helper
    * @return: false
    * @modification:
    */
    redirect: function (component, event, helper) {
        
        var eventGoFiliali = $A.get("e.c:eventGetIntervista");
        eventGoFiliali.setParams({
            'datafilialList':component.get("v.dataList"),
            'loadData':false
        });
        eventGoFiliali.fire();
        //window.history.back();
    },
    /**
    * @description: method for call appun
    * @date::12/03/2019
    * @author:Salimata NGOM
    * @params: component, event, helper
    * @return:
    * @modification:
    */
    nonRisponde: function (component, event, helper) {
        /*
        var intervista = component.get('v.nuovaIntervista');
        intervista.COM_Stato_Avanzamento_Intervista__c = 'Non Risponde';
        intervista.COM_Status__c = 'Archived';
        intervista.COM_interview_accepted__c = false;
        intervista.COM_Intervista_Accettata__c = 'NO';
        intervista.COM_Intervista_Utile__c = 'NO';
        intervista.COM_Intervista_Non_Utile__c = true;
        intervista.COM_Interview_Utils__c = false;
        intervista.COM_count_non_risp__c = 1;

        console.log('\n---03_04_2019---\n');
        console.log(intervista);

        var action = component.get('c.updateIntervista');
        action.setParam('param', intervista);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.nuovaIntervista', response.getReturnValue());
                console.log('in success', response.getReturnValue());
                // var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
                //     eventRefreshIntervista.fire()

                // helper.showToast('Stato aggiornato in Irreperibile.Salvataggio con successo', 'SUCCESS');
                component.set('v.nonRisposta', false);
            } else {
                helper.showToast('Salvataggio non effettuato!', 'ERROR');
            }
        });
        $A.enqueueAction(action);
        */
        var numberNonrisponde = component.get('v.numNonRisponde');
        component.set('v.numNonRisponde', numberNonrisponde + 1);
        component.set('v.isrispondeNo', true);
        component.set('v.BooleanCounterAppointment',true);
        component.set('v.nonRisposta', false);
        component.set('v.responde', false);
    },
    /**
    * @description: method for set risponde as true
    * @date::12/03/2019
    * @author:Salimata NGOM
    * @params: component, event, helper
    * @return: Integer
    * @modification:
    */
    risponde: function (component, event, helper) {
        component.set('v.responde', true);
    },
    /**
    * @description: method for check if risponde or no and call a component corresponding
    * @date::13/03/2019
    * @author:Salimata NGOM
    * @params: component, event, helper
    * @return: none
    * @modification:
    */
    getIntervistaDomande: function (component, event, helper) {
            component.set('v.isRispostaExist', false);
            component.set('v.nonRisposta', false);
            component.set('v.isrispondeSi', true);
            component.set('v.isrispondeNo', false);
            component.set('v.responde', false);
        //check if risponde is Si
        /*
        var source = event.getSource();
        var selectedRisponde = source.get('v.value');
        if (selectedRisponde == 'Si') {

            component.set('v.isRispostaExist', false);
            component.set('v.nonRisposta', false);
            component.set('v.isrispondeSi', true);
            component.set('v.isrispondeNo', false);
            component.set('v.responde', false);
        } else if (selectedRisponde == 'No') {

            component.set('v.isrispondeNo', true);
            component.set('v.isrispondeSi', false)
            component.set('v.isRispostaExist', false);
            component.set('v.nonRisposta', false);
        }*/
    },
    /**
    * @description: method for get refresh Response Intervista
    * @date::18/03/2019
    * @author:Salimata NGOM
    * @params: component, event
    * @return: none
    * @modification:
    */
    setDomandaTrattDati: function( component , event , helper )
    {
        var source = event.getSource();
        var selectedRisponde = source.get('v.value');
        if( selectedRisponde == 'Si' )
        {
            component.set('v.isDomandaTrattDati', true);
        }else if( selectedRisponde == 'No' )
        {
            component.set('v.isDomandaTrattDati', false);
            component.set('v.isrispondeNo', true);
            component.set('v.isrispondeSi', false)
            component.set('v.isRispostaExist', false);
            component.set('v.nonRisposta', false);
            component.set('v.BooleanCounterAppointment',false);
        }
     
    },
    refreshResponse: function (component, event) {
        component.set('v.responde', false);
        var idintervista = component.get("v.Id");
        //call apex class method
        var action = component.get('c.getDettagliIntervista');
        // pass the apex method parameters to action
        action.setParams({
            'idintervista': idintervista
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in paginationList attribute on component.
                component.set('v.nuovaIntervista', response.getReturnValue());
                //alert('result'+JSON.stringify(response.getReturnValue()));
            } else {
                console.log('error');
            }
        });
        $A.enqueueAction(action);
        //check if risposta if intervista exist

        var action2 = component.get('c.getRisposta');
        action2.setParams({ 'idIntervista': idintervista });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.risposta', response.getReturnValue());
                component.set('v.isRispostaExist', true);
                component.set("v.toggleSpinner", false);
                component.set("v.SpinnerSearch", false);
                component.set('v.nonRisposta', false);
                component.set('v.responde', false);
                component.set('v.isrispondeNo', false);
                component.set('v.isrispondeSi', false)
            }
        });
        $A.enqueueAction(action2);




    },
    /**
    * @description: method for show spinner for salvare domanda
    * @date::18/03/2019
    * @author:Salimata NGOM
    * @params: component, event, helper
    * @return: none
    * @modification:
    */
    showSpinnerDomanda: function (component, event, helper) {
        console.log('show spinner');
        //  component.set("v.toggleSpinner", true);
        //  component.set("v.SpinnerSearch", true);
    },

    /**
    * @description: method for show spinner for salvare domanda
    * @date::19/03/2019
    * @author:Salimata NGOM
    * @params: component, event, helper
    * @return: none
    * @modification:
    */
    modificaDomanda: function (component, event, helper) {
        var risposta = event.getParam('rispostaObject');
        component.set('v.risposta', risposta);
        console.log('risposta of domande=', JSON.stringify(risposta));
        component.set('v.isRispostaExist', false);
        component.set('v.isupdateResponse', true);

    },
    /**
    * @description: method for set  COM_Stato_Avanzamento_Intervista__c will became “Irreperibile”
    * @date::10/03/2019
    * @author:Salimata NGOM
    * @params: component, event, helper
    * @return: none
    * @modification:
    */
    irreperibile: function (component, event, helper) {
        var intervista = component.get('v.nuovaIntervista');
        intervista.COM_Stato_Avanzamento_Intervista__c = 'Irreperibile';
        intervista.COM_Status__c = 'Archived';
        intervista.COM_interview_accepted__c = false;
        intervista.COM_Intervista_Accettata__c = 'NO';
        intervista.COM_Intervista_Utile__c = 'NO';
        intervista.COM_Intervista_Non_Utile__c = true;
        intervista.COM_Interview_Utils__c = false;

        console.log('\n---03_04_2019---\n');
        console.log(intervista);

        var action = component.get('c.updateIntervista');
        action.setParam('param', intervista);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.nuovaIntervista', response.getReturnValue());
                console.log('in success', response.getReturnValue());
                var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
                eventRefreshIntervista.fire()
                /*
                helper.showToast('Stato aggiornato in Irreperibile.Salvataggio con successo', 'SUCCESS');
                component.set('v.nonRisposta',false);*/
            } else {
                helper.showToast('Salvataggio non effettuato!', 'ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    /**
    * @description: method for set  COM_Stato_Avanzamento_Intervista__c will became “Non accetta”
    * @date::10/03/2019
    * @author:Salimata NGOM
    * @params: component, event, helper
    * @return: none
    * @modification:
    */
    nonAccetta: function (component, event, helper) {

        var intervista = component.get('v.nuovaIntervista');
        intervista.COM_Stato_Avanzamento_Intervista__c = 'Non accetta';
        intervista.COM_Status__c = 'Archived';
        intervista.COM_interview_accepted__c = false;
        intervista.COM_Intervista_Accettata__c = 'NO';
        intervista.COM_Intervista_Utile__c = 'NO';
        intervista.COM_Interview_Utils__c = false;
        intervista.COM_Intervista_Non_Utile__c = true;

        console.log('\n---03_04_2019---\n');
        console.log(intervista);
        var action = component.get('c.updateIntervista');
        action.setParam('param', intervista);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.nuovaIntervista', response.getReturnValue());
                console.log('in success', response.getReturnValue());
                var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
                eventRefreshIntervista.fire()
                /*
                helper.showToast('Stato aggiornato in Non accetta.Salvataggio con successo', 'SUCCESS');
                component.set('v.nonRisposta',false);*/
            } else {
                helper.showToast('Salvataggio non effettuato!', 'ERROR');
            }
        });
        $A.enqueueAction(action);
    }

})