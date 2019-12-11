({
    setSoddisfatto: function(component, event, helper) {
      var risposte = component.get("v.risposte");
      var riposteValue = event.getSource().get("v.value");
      risposte.D6__c = riposteValue;
      var recedereBtn = component.find("assTracc");
      recedereBtn.forEach(function(element) {
        element.set("v.disabled", false);
      });
      var assTraccNote = component.find("assTraccNote");
      assTraccNote.set("v.disabled", false);
    },
    setRecedere: function(component, event, helper) {
      var risposte = component.get("v.risposte");
      var recedere = event.getSource().get("v.value");
      risposte.D7__c = recedere;
      var validateBtn = component.find("validateBtn");
      if (recedere == "Si") {
        component.set("v.showMotivazione", true);
        validateBtn.set("v.disabled", true);
      } else if (recedere == "No") {
        component.set("v.showMotivazione", false);
        validateBtn.set("v.disabled", false);
      }
    },
    setMotivazione: function(component, event, helper) {
      var risposte = component.get("v.risposte");
      var motivazioneValue = event.getSource().get("v.value");
      var validateBtn = component.find("validateBtn");
      validateBtn.set("v.disabled", false);
      risposte.D8__c = motivazioneValue;
      
      //var allIds = component.find("assTracc");
      var textareaNote = component.find("assTraccNote");
      //var textarea = allIds.find({ instancesOf: "lightning:input" });
        console.log("allIds >>>>>", textareaNote);
      if (motivazioneValue == "Altro") {
        console.log("textareaNote >>>>>", JSON.stringify(textareaNote));
        textareaNote.set("v.required", true);
      } else {
        //var textareaNote = component.find("assTracc");
        console.log(textareaNote);
        textareaNote.set("v.required", false);
      }
      console.log("risposte dans setMotivazione >>", JSON.stringify(risposte));
    },
    concludiIntervista: function(component, event, helper) {
      var intervista = component.get("v.intervistaIntegrativo");
      var risposte = component.get("v.risposte");
      risposte.COM_Note_Soddisfazione_Cliente__c = component.get("v.noteSoddisfatto");
      risposte.COM_Note_Motivazione_Recesso__c = component.get("v.noteRecesso");
      risposte.Intervista_integrativo__c = intervista.Id;
      risposte.Name = intervista.Name;
      console.log(
        "risposte dans concludiIntervista >>",
        JSON.stringify(risposte)
      );
  
      intervista.COM_Ultimo_Esito__c = "Conclusa";
      intervista.Stato__c = "Conclusa";
      intervista.Status__c = "Archived";
      intervista.COM_Intervista_Utile__c = "S";
      intervista.COM_Data_Esito__c = new Date();
      /* intervista.COM_interview_accepted__c = true;
      intervista.COM_Intervista_Accettata__c = "SI"; */
      console.log(
        "intervista dans concludiIntervista >>",
        JSON.stringify(intervista)
      );
      var validNote = component
        .find("assTracc")
        .reduce(function(validSoFar, inputCmp) {
          // Displays error messages for invalid fields
          inputCmp.showHelpMessageIfInvalid();
          return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
      // If we pass error checking, do some real work
      if (validNote) {
        var textar = component.find("assTraccNote");
        textar.showHelpMessageIfInvalid();
        if (textar.get("v.validity").valid) {
            //Save final Intervista & Risposte
          helper.saveIntervista(component, intervista);
          helper.saveRisposte(component, risposte);
          helper.showToast(
            "Salvataggio con successo, intervista finita!",
            "SUCCESS"
          );
          console.log("Redirect vers page d'accueil");
          var eventToNavigate = $A.get("e.c:eventNavigateToIntervistaFuturo");
          eventToNavigate.fire();
          
        } else {
          helper.showToast(
            "Salvataggio non effettuato, Nota è richiesta!",
            "ERROR"
          );
        }
        
      }else{
          helper.showToast(
            "Salvataggio non effettuato, controlla il campo!",
            "ERROR"
          );
      }
      
  
    },
    cancelRiposta: function(component, event, helper){
      var previousQuestion = component.get("v.previousQuestion");
      console.log("previousQuestion >>>", previousQuestion);
      /* if(previousQuestion == 1){
      }else if(previousQuestion == 2){
      }else if(previousQuestion == 3){
      }else if(previousQuestion == 4){
      } */
      //var question = component.get("v.question");
      var data = {
        currentQuestion: previousQuestion ,
      };
      console.log("data previousQuestion >>>", data.currentQuestion);
      var eventRipostaCancel = $A.get("e.c:EventRipostaCancel");
      eventRipostaCancel.setParams({
        cancelQuestion: data
      });
      eventRipostaCancel.fire();
      console.log("EventRipostaCancel event fired");
    }
  });