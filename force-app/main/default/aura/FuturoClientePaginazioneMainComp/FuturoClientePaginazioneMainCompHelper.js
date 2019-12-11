({
  /**
   * @description: Function to fetch data from server called in initial loading of page
   * @date::17/05/2019
   * @author:Mame Seynabou Diop
   * @return: none
   * @modification: 20/06/2019
   */
  fetchCommodities: function (component, event, helper) {
    var action = component.get("c.getCommodities");
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS" && component.isValid()) {
        var result = response.getReturnValue();
        if (result.error == true) {
          var toastParams = {
            title: "Error",
            message: "Unknown error", // Default error message
            type: "error"
          };
          toastParams.message = result.message;
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams(toastParams);
          toastEvent.fire();
        } else {
          var dataSurveyList = result.data;
          var listByAgente=[];
          var conforme=0;
          var target=0;
          var listArchived=[];
          var object= {sobjectype:"Com_Commodity_Survey__c",Id:" ",COM_Status_FUTURO__c:" "};
          dataSurveyList.forEach(function(element) {
           if (!listByAgente.includes(element.COM_AGENTE_FUTURO__r.Name)){
            listByAgente.push(element.COM_AGENTE_FUTURO__r.Name);
              }
           });
console.log(listByAgente.length);
listByAgente.forEach(function(element1) {
conforme=0;
listArchived=[];
dataSurveyList.forEach(function(element2) {
 if(element1===(element2.COM_AGENTE_FUTURO__r.Name)){
  target=element2.COM_AGENTE_FUTURO__r.Com_Numero_Contatti__c;
  if(element2.COM_PraticheChiuse_Conforme__c==1){
    conforme+=element2.COM_PraticheChiuse_Conforme__c;
  }
  listArchived.push(element2);
   }
  });
  var listUpdate=[];
  if(target===conforme || target<conforme){
    listArchived.forEach(function(status) { 
      object={};
      object.Id=status.Id;
      status.COM_Status_FUTURO__c="Archived";
      object.COM_Status_FUTURO__c=status.COM_Status_FUTURO__c;
      listUpdate.push(object);
    });
       var action3 = component.get("c.updateListSobject");
       action3.setParam("mySobject", listUpdate);
       action3.setCallback(this, function (response) {
           var state = response.getState();
           console.log(state);
           if (state === "SUCCESS") {  
            console.log("liste par agence", JSON.stringify(listUpdate)); 
           }
       });
       $A.enqueueAction(action3);
}
});
}
} else if (state === "ERROR") {
        alert("error");

     var toastParams = {
          title: "Error",
          message: "Unknown error", // Default error message
          type: "error"
        };

          toastParams.message = message;
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams(toastParams);
          toastEvent.fire();
        
      }
    });
    $A.enqueueAction(action);
    var action1 = component.get("c.getCommodities");
    action1.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS" && component.isValid()) {
        var result = response.getReturnValue();
          var dataList = result.data;
         console.log("liste finale", JSON.stringify(dataList)); 
          $A.createComponent(
            "c:FuturoClientePaginazione",
            {
              objectList: dataList,
              ToAgente: false,
              mostraConttati: component.get('v.mostraConttati'), 
              pratiche: component.get("v.pratiche"),
              keyMonth: component.get("v.keyMonth"),
              keyYear:component.get("v.keyYear"),
              keyTotal:component.get("v.keyTotal")
            },
            function (newCmp) {
              if (component.isValid()) {
                component.set("v.body", newCmp);
              }
            }
          );
        }
      });
      $A.enqueueAction(action1);
},

  fetchCommoditiesByAgente: function (component, event) {
    var agentId = event.getParam("agenteId");
    var action = component.get("c.getCommoditiesByAgente");
    action.setParam("agenteId", agentId);
    action.setCallback(this, function (response) {
      if (response.getState() === "SUCCESS") {
        var dataResponse = response.getReturnValue();
        if (dataResponse.error == false) {
          var commoditiesList = dataResponse.commodities;
          component.set("v.dataSurveyList", commoditiesList);
          $A.createComponent(
            "c:FuturoClientePaginazione",
            {
              objectList: commoditiesList,
              ToAgente: true
            },
            function (newCmp) {
              if (component.isValid()) {
                component.set("v.body", newCmp);
              }
            }
          );
        } else {
          alert("ERROR");
        }
      } else {
      }
    });
    $A.enqueueAction(action);
  },
  
      
});