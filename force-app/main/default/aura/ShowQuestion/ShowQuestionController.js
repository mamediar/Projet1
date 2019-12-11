({
  setRiposta: function(component, event, helper) {
      var riposta = event.getSource().get("v.value");
      var validateBtn = component.find("validateBtn");
      validateBtn.set("v.value", riposta);
      validateBtn.set("v.disabled", false);
  },
  validateRiposta: function(component, event, helper) {
    var riposta = event.getSource().get("v.value");
    var question = component.get("v.question");
    var validateBtn = component.find("validateBtn");
    validateBtn.set("v.disabled", true);
    var data = {
      fieldToStore: question.fieldToStore,
      value: riposta,
      num_question: question.num_question,
      //type: type
    };  
    var eventRipostaValidate = $A.get("e.c:EventRipostaValidate");
    eventRipostaValidate.setParams({
      responseQuestion: data
    }); 
    eventRipostaValidate.fire();
    console.log("event fired");
  },
  cancelRiposta: function(component, event, helper){
    var question = component.get("v.question");
    var data = {
      previousQuestion: question.previousQuestion,
      currentQuestion: question.num_question
      //type: type
    };
    var eventRipostaCancel = $A.get("e.c:EventRipostaCancel");
    eventRipostaCancel.setParams({
      cancelQuestion: data
    });
    eventRipostaCancel.fire();
    console.log("EventRipostaCancel event fired");
  }
});