({
    /**
     * @description : To show Toast
     * @author: Khadim Rassoul Ndeye
     * @date: 13/03/2019
     * @param message
     * @param type
     */
    showToast: function(message, type) {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        message: message,
        type: type
      });
      toastEvent.fire();
    },
    
    saveIntervista: function(component, intervista) {
      var action = component.get("c.updateIntervista");
      action.setParam("param", intervista);
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          component.set("v.IntervistaIntegrativo", response.getReturnValue());
        } else {
          this.showToast("Salvataggio non effettuato!", "ERROR");
          console.log(response.getError()[0]);
        }
      });
      $A.enqueueAction(action);
    },
  
    saveRisposte: function(component, risposte) {
      var action = component.get("c.addResponse");
      action.setParam("respdomanda", risposte);
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          component.set("v.risposte", response.getReturnValue());
        } else {
          this.showToast("Salvataggio non effettuato!", "ERROR");
          console.log(response.getError()[0]);
        }
      });
      $A.enqueueAction(action);
    }
  });