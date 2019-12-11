({
    /**
   * @description: method to check statut
   * @date:17/05/2019
   * @author:
   * @modification:
   */
    doInit: function(component, event, helper) {
        var intervistaIntegrativo = component.get("v.IntervistaIntegrativo");
        //var productsLimites = component.get("v.productsLimites");
        //console.log('productsLimites in newComponent: >>>', JSON.stringify(productsLimites));
        var sex = intervistaIntegrativo.Ac_Sesso__c == "M" ? "Sig. " : "Sig.ra ";
        component.set("v.sesso", sex);
        if(intervistaIntegrativo.Stato__c == 'Conclusa'){
            component.set("v.AvivoIntervista", false);
            helper.getRispostaIntervista(component);
            component.set("v.isConclusa", true);
        }else{
            component.set("v.AvivoIntervista", true);
            helper.setComodityCheklist(component);
            helper.setProcessing(component);
        }
        //console.log("Status:>>>>", IntervistaIntegrativo.Status__c);
        /* var toastEvent = $A.get("e.force:showToast");
        //impossible to start the interview
        if (IntervistaIntegrativo.Status__c == "Processing") {
            //blocked interview
            component.set("v.AvivoIntervista", false);
            //show message
            toastEvent.setParams({
                title: "Error",
                message:
                "Non e possibile procedere, intervista in corso da altro operatore."
            });
            toastEvent.fire();
        }
        else if (IntervistaIntegrativo.Status__c == "New") {
            //console.log('Teste limite Plc_Tipo_Prodotto__c:>>>', IntervistaIntegrativo.Plc_Tipo_Prodotto__c);
            //console.log('Teste limite:>>>', productsLimites[IntervistaIntegrativo.Plc_Tipo_Prodotto__c]);
            if (productsLimites[IntervistaIntegrativo.Plc_Tipo_Prodotto__c]) {
                //blocked interview
                component.set("v.AvivoIntervista", false);
                //show message
                toastEvent.setParams({
                    title: "Error",
                    message: "Non e possibile procedere, il limite mensile raggiunto."
                });
                toastEvent.fire();
            } else {
                //activated interview
                component.set("v.AvivoIntervista", true);
                helper.setComodityCheklist(component);
                helper.setProcessing(component);
                //component.set("v.questions", helper.listQuestions(component));        
            }
        } */
    },
    
    /**
   * @description: method to get details customer
   * @date:17/05/2019
   * @author: Khadim Rassoul Ndeye
   * @modification:
   */
    showIntervistaIntegrativo: function(component, event, helper) {
        var IntervistaIntegrativo = event.getParam("IntervistaIntegrativo");
        component.set("v.IntervistaIntegrativo", IntervistaIntegrativo);
        console.log(
            "IntervistaIntegrativo " + JSON.stringify(IntervistaIntegrativo)
        );
    },
    
    /**
   * @description: shows that the customer is not answering the phone
   * @date:17/05/2019
   * @author: Khadim Rassoul Ndeye
   * @modification:
   */
    nonRispondeAlTelefono: function(component, event, helper) {
        helper.salvareAppuntamento(component);
    },
    
    /**
   * @description: customer not to be found
   * @date:17/05/2019
   * @author:
   * @modification:
   */
    irreperibile: function(component, event, helper) {
        helper.changeStato(component, "Irreperibile");
    },
    
    /**
   * @description: method to open the model to save a appointment
   * @date:17/05/2019
   * @author:
   * @modification:
   *
   */
    nonAccettaIntervista: function(component, event, helper) {
        helper.changeStato(component, "Non accetta");
        //component.set("v.fissareAppuntamento", true);
    },
    
    /**
   * @description: redirect to the list of Intervista Integrativo
   * @date:17/05/2019
   * @author:
   * @modification:
   */
    redirect: function(component, event, helper) {
        helper.redirect(component);
    },
    
    /**
   * @description: get request
   * @date:17/05/2019
   * @author:
   * @modification:
   */
    getIntervistaDomande: function(component, event, helper) {
        var riposta = event.getSource().get("v.value");
        var disponibileBtn = component.find("disponibileBtn");
        disponibileBtn.set("v.value", riposta);
        disponibileBtn.set("v.disabled", false);
    },
    
    /**
   * @description: method to save the Appointment
   * @date:17/05/2019
   * @author:
   * @modification:
   */
    salvaAppuntamento: function(component, event, helper) {
        component.set("v.fissareAppuntamento", false);
    },
    
    /**
   * @description: startInteriew
   * @date:17/05/2019
   * @author:
   * @modification:
   */
    startInteriew: function(component, event, helper) {
        var riposta = event.getSource().get("v.value");
        var startInterviewBtn = component.find("startInterviewBtn");
        startInterviewBtn.set("v.value", riposta);
        startInterviewBtn.set("v.disabled", false);
        
        
    },
    handleEventRipostaValidate: function(component, event, helper) {
        var responseQuestion = event.getParam("responseQuestion");
        console.log(
            "value of num_question in handleEventRipostaValidate, reception fired",
            responseQuestion.num_question
        );
        console.log(
            "value of responseQuestion nameResponse in handleEventRipostaValidate, reception fired",
            responseQuestion.fieldToStore
        );
        console.log(
            "value of responseQuestion value in handleEventRipostaValidate, reception fired",
            responseQuestion.value
        );
        if (responseQuestion.num_question == 1){
            helper.processQuestion1(component, responseQuestion);
        }
        if (responseQuestion.num_question == 2) {
            helper.processQuestion2(component, responseQuestion);
        }
        
        if (responseQuestion.num_question == 3) {
            helper.processQuestion3(component, responseQuestion);
        }
        if (responseQuestion.num_question == 4) {
            helper.processQuestion4(component, responseQuestion);
        }
        console.log(
            "newRiposte >>>",
            JSON.stringify(component.get("v.newRiposte"))
        );
    },
    handleEventRipostaCancel: function(component, event, helper) {
        var cancelQuestion = event.getParam("cancelQuestion");
        console.log(
            "value of num_question in handleEventRipostaCancel, reception fired",
            JSON.stringify(cancelQuestion)
        );
        if (cancelQuestion.currentQuestion == 1){
            helper.cancelQuestion1(component);
        }
        if (cancelQuestion.currentQuestion == 2){
            helper.cancelQuestion2(component);
        }
        if (cancelQuestion.currentQuestion == 3){
            helper.cancelQuestion3(component);
        }
        if (cancelQuestion.currentQuestion == 4){
            helper.cancelQuestion4(component);
        }
        if (cancelQuestion.previousQuestion == 1){
            helper.cancelPreviousQuestion1(component);
        }
        if (cancelQuestion.previousQuestion == 2){
            helper.cancelPreviousQuestion2(component);
        }
    },
    validateDisponibile: function(component, event, helper){
        var value = event.getSource().get("v.value");
        var risposte = component.get("v.newRiposte");
        component.set("v.previousQuestion", 1);
        if (value == "NonDisponibile") {
            var IntervistaIntegrativo = component.get("v.IntervistaIntegrativo");
            risposte.D0__c = 'NON DISPONIBILE';
            var dateScadenzaRecesso = helper.getFormattedDate(IntervistaIntegrativo.COM_Data_Scadenza_Recesso__c);
            var textApputamento = "Chiedere quando è possibile richiamare e fissare ricontatto entro il " + dateScadenzaRecesso;
            component.set("v.textApputamento", textApputamento);
            component.set("v.fissareAppuntamento", true);
            component.set("v.startInterview", false);
            component.set("v.makeInterview", false);
        } else {
            risposte.D0__c = 'DISPONIBILE';
            component.set("v.fissareAppuntamento", false);
            component.set("v.startInterview", true);
            component.set("v.makeInterview", false);
        }
        var disponibileBtn = component.find("disponibileBtn");
        disponibileBtn.set("v.disabled", true);
        component.set("v.isDisponibile", false);
    },
    validateStartInterview: function(component, event, helper){
        var value = event.getSource().get("v.value");
        component.set("v.previousQuestion", 2);
        var risposte = component.get("v.newRiposte");
        if (value == "No") {
            risposte.D1__c = 'No/Non adesso';
            var IntervistaIntegrativo = component.get("v.IntervistaIntegrativo");
            var dateScadenzaRecesso = helper.getFormattedDate(IntervistaIntegrativo.COM_Data_Scadenza_Recesso__c);
            var textApputamento = "Nessun problema "+ helper.getTitleAndName(component)+", quando posso richiamarla? (entro il " + dateScadenzaRecesso + ")";
            component.set("v.textApputamento", textApputamento);
            component.set("v.fissareAppuntamento", true);
            component.set("v.makeInterview", false);
        } else {
            risposte.D1__c = 'Si';
            component.set("v.fissareAppuntamento", false);
            component.set("v.makeInterview", true);
        }
        component.set("v.startInterview", false);
        component.set("v.isDisponibile", false);
    },
    cancelStartInterview: function(component, event, helper){
        component.set("v.startInterview", false);
        component.set("v.isDisponibile", true);
    }
});