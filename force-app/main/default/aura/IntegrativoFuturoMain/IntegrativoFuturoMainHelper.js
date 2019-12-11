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
              PF: customSettings.COM_Limite_mensile_prodotto_PF__c,
              limitFuturo : customSettings.Limite_mensile_futuro__c,
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
          console.log("ERROR: >>>", message);
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
      var action = component.get("c.countIntervistaConclusa");
      action.setCallback(this, function(response) {
        var state = response.getState();
        //console.log(JSON.stringify(response))
        if (state === "SUCCESS") {
          var datas = response.getReturnValue();
          var productsLimites = component.get("v.productsLimites");
           // set true or false if limite mensile Futuro = number of conclude intervista
          productsLimites["limitFuturo"] = (productsLimites["limitFuturo"] == datas.nbrItervista) || 
          (productsLimites["limitFuturo"] < datas.nbrItervista);

          if (productsLimites.limitFuturo) {
            component.set("v.dataIntervistaList", []);
            //blocked interview
            //show message
           /* var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning",
                type: "warning",
                message: "Non e possibile procedere, il limite mensile raggiunto."
            });
            toastEvent.fire(); */
          } 


          console.log('limitFuturo >>>:', productsLimites["limitFuturo"] < datas.nbrItervista);
          var storeResponse = component.get("v.dataIntervistaList");
          component.set("v.dataIntervistaList", storeResponse);
          //component.set("v.intervistaFuturoList", storeResponse);
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
          this.createIntegrativoFuturo(component);
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
    createIntegrativoFuturo: function(component/* , intervistaFuturo */){
      /* if(intervistaFuturo){
        console.log('intervistaFuturo >>: ', intervistaFuturo);
      var found = intervistaFuturoList2.find(function(element) {
        return element.Id == intervistaFuturo.Id;
      });
      console.log('indexOf intervistaFuturo >>: ', intervistaFuturoList2.indexOf(found));
      } */
      var intervistaFuturoList2 = component.get('v.dataIntervistaList');
      var productsLimites2 = component.get('v.productsLimites');
      var filterList2 = component.get("v.filterList");
      $A.createComponent(
          "c:IntegrativoFuturo", {
              'dataIntervistaList':intervistaFuturoList2,
              'productsLimites':productsLimites2,
              'filterList':filterList2
          },
          function(newCmp) {
              if (component.isValid()) {
                  component.set("v.body", newCmp);
              }
          }
      );
    }
  });