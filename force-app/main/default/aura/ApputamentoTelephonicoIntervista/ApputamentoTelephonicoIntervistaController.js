({
  redirect: function(component, event, helper) {
    var eventGoFiliali = $A.get("e.c:eventGetIntervista");
    eventGoFiliali.fire();
  },
  clickCreate: function(component, event, helper) {
      var inputs = component.find("richiamare");
      inputs.forEach(function(element) {
        console.log('element empty>>>', element);
        console.log('element .get("v.value")>>>', element.get("v.value"));
        if(!element.get("v.value")){
          element.set("v.required", true);
          console.log('element empty');
        }
      });
    var validExpense = inputs.reduce(function(validSoFar, inputCmp) {
        inputCmp.showHelpMessageIfInvalid();
        return validSoFar && inputCmp.get("v.validity").valid;
      }, true);
    // If we pass error checking, do some real work
    if (validExpense) {
      var date = component.get("v.richiamareDate");
      var time = component.get("v.richiamareTime");
      var charsDate = date.split("-");
      var charsTime = time.split(":");
      var dateTime = new Date(
        charsDate[0],
        charsDate[1] - 1,
        charsDate[2],
        charsTime[0],
        charsTime[1]
      );
      helper.checkDate(component, dateTime);
    }
  },
  notInterested: function(component, event, helper) {
    helper.getNotInterested(component);
  },
  /**
   * @description: redirect to the list of Intervista Integrativo
   * @date:17/05/2019
   * @author:
   * @modification:
   */
  redirect: function(component, event, helper) {
      var previousQuestion = component.get("v.previousQuestion");
      var data = {
          previousQuestion: previousQuestion,
          currentQuestion: 0
      };
      var eventRipostaCancel = $A.get("e.c:EventRipostaCancel");
      eventRipostaCancel.setParams({
          cancelQuestion: data
      });
      eventRipostaCancel.fire();
      console.log("EventRipostaCancel event fired");
  },
});