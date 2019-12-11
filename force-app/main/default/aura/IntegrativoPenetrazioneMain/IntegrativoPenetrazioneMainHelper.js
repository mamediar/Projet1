({
  doInit: function(component, event, helper) {
    var currentDate = new Date();
    var curDate = Date.parse(currentDate);
    component.set("v.curDate", curDate);
    try {
      component.set("v.currentDate", Date.parse(currentDate));
    } catch (e) {
      console.error(e);
    }
    var action = component.get("c.getAllIntervistaWithoutFilter");
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var storeResponse = response.getReturnValue()["data"];
        var countConclus = response.getReturnValue()["countConclus"];
       //console.log("countConclus: >>>", countConclus);
        storeResponse = this.parseDateArray(storeResponse);
        var customSettings = response.getReturnValue().customSettings;
        component.set("v.customSettings", customSettings);
        //Set product's Limites
        var productsLimites = {};
        if (customSettings.length == 1) {
          customSettings = customSettings[0];
          productsLimites = {
            "PP Altri": customSettings.COM_Limite_mensile_prodotto_PP_Altri__c,
            PA: customSettings.COM_Limite_mensile_prodotto_PA__c,
            "PP Borg": customSettings.COM_Limite_mensile_prodotto_PF_Borg__c,
            PF: customSettings.COM_Limite_mensile_prodotto_PF__c
          };
        } else {
        }
        component.set("v.productsLimites", productsLimites);

        var arraysOfNames = [];
        storeResponse.forEach(function(element) {
          if (!arraysOfNames.includes(element.Plc_Tipo_Prodotto__c)) {
            arraysOfNames.push(element.Plc_Tipo_Prodotto__c);
          }
        });

        component.set("v.filterList", arraysOfNames);
        //component.set("v.objectList", []);

        /* 
        ** Filter data for intermediary limit
        */
       var conclus = storeResponse.filter(
        row =>
         ( row.Stato__c === "Conclusa") && 
         (row.Status__c === "Archived") &&
         ( row.COM_Current_Period__c==true)
      );
      
     //console.log('conclus filterd', conclus);
      /* conclus.forEach(function(element) {
       //console.log(element);
      }); */
      var limitedIntermediario = [];
      conclus.forEach(function(obj) {
        countConclus.forEach(function(element) {
          if((obj.Ragione_Sociale_Intermediario__c == element.Ragione_Sociale_Intermediario__c) && 
            !(obj.COM_Intervista_Number__c > element.countConclus)){
             //console.log('is limited >>', obj);
              limitedIntermediario.push(obj.Ragione_Sociale_Intermediario__c);
              /* storeResponse = storeResponse.filter(
                row =>
                 (row.Stato__c != "Conclusa") && 
                 (row.Stato__c != "Conclusa" && row.Ragione_Sociale_Intermediario__c != obj.Ragione_Sociale_Intermediario__c) && 
                 ( row.COM_Current_Period__c==true)
              ); */
          }
        });
      });
      limitedIntermediario = limitedIntermediario.filter((v, i, a) => a.indexOf(v) === i)
     //console.log('counter newData', storeResponse);
      component.set("v.limitedIntermediario", limitedIntermediario);
      component.set("v.dataIntervistaList", storeResponse);
        //this.getIntervisteDelmeseByProduct(component);

      } else if (state === "ERROR") {
        let errors = response.getError();
        let message = "Unknown error"; // Default error message
        // Retrieve the error message sent by the server
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message = errors[0].message;
        }
        // Display the message
        console.error(message);
       //console.log("ERROR: >>>", message);
      }
    });
    $A.enqueueAction(action);
  },
  parseDateArray: function(data) {
    data.forEach(function(element, index) {
      if (element.COM_Richiamare_il__c)
        element.COM_Richiamare_il__c = Date.parse(element.COM_Richiamare_il__c);
      data[index] = element;
    });
    return data;
  },
  getIntervisteDelmeseByProduct: function(component) {
    var action = component.get("c.countInterviewProduct");
    action.setCallback(this, function(response) {
      var state = response.getState();
      //console.log(JSON.stringify(response))
      if (state === "SUCCESS") {
        var datas = response.getReturnValue();
        //component.set("v.dashbord", datas);
        var productsLimites = component.get("v.productsLimites");
        productsLimites["PA"] = productsLimites["PA"] < datas.PAConclusa;
        productsLimites["PP Altri"] =
          productsLimites["PP Altri"] < datas.PPAltriConclusa;
        productsLimites["PP Borg"] =
          productsLimites["PP Borg"] < datas.PPBorgConclusa;
        //productsLimites["PP Borg"] = true;
        var storeResponse = component.get("v.dataIntervistaList");
        storeResponse = storeResponse.filter(function(element) {
          return !productsLimites[element.Plc_Tipo_Prodotto__c];
        });
        component.set("v.dataIntervistaList", storeResponse);
        //component.set("v.intervistaPenetrazioneList", storeResponse);
        var curDate = component.get("v.curDate");
        storeResponse = storeResponse.filter(
          row =>
            ((row.Stato__c === "Richiamare" &&
              row.COM_Richiamare_il__c < curDate) ||
              (row.Stato__c === "Non risponde" &&
                row.COM_Richiamare_il__c < curDate) ||
              (row.Stato__c === "Non accetta" &&
                row.COM_Richiamare_il__c < curDate) ||
              row.Stato__c === "vuoto") &&
            row.Status__c != "Archived"
        );
        this.createIntegrativoPenetrazione(component);
        //this.initializePagination(component, storeResponse);
      } else if (state === "ERROR") {
        // Process error returned by server
        this.handleErrors(response.getError())
        }else {
            this.handleErrors([])
      }
    });
    $A.enqueueAction(action);
  },
  handleErrors: function(errors) {
    // Configure error toast
    var toastParams = {
      title: "Error",
      message: "Unknown error", // Default error message
      type: "error"
    };
    // Pass the error message if any
    if (errors && Array.isArray(errors) && errors.length > 0) {
      toastParams.message = errors[0].message;
    }
    // Fire error toast
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams(toastParams);
    toastEvent.fire();
  },
  createIntegrativoPenetrazione: function(component/* , intervistaPenetrazione */){
    /* if(intervistaPenetrazione){
     //console.log('intervistaPenetrazione >>: ', intervistaPenetrazione);
    var found = intervistaPenetrazioneList2.find(function(element) {
      return element.Id == intervistaPenetrazione.Id;
    });
   //console.log('indexOf intervistaPenetrazione >>: ', intervistaPenetrazioneList2.indexOf(found));
    } */
    var intervistaPenetrazioneList2 = component.get('v.dataIntervistaList');
    var productsLimites2 = component.get('v.productsLimites');
    var filterList2 = component.get("v.filterList");
    var limitedIntermediario = component.get("v.limitedIntermediario");
    $A.createComponent(
        "c:IntegrativoPenetrazione", {
            'dataIntervistaList':intervistaPenetrazioneList2,
            'productsLimites':productsLimites2,
            'filterList':filterList2,
            'limitedIntermediario':limitedIntermediario
        },
        function(newCmp) {
            if (component.isValid()) {
                component.set("v.body", newCmp);
            }
        }
    );
  }
});