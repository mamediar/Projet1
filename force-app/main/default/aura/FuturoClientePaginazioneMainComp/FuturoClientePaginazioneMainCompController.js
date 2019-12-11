({
  /**
   * @description: method go To FuturoImpaginazioneComp 
   * @date::16/03/2019
   * @author:Mady COLY
   * @modification: none
   */
	doInit: function(component, event, helper) {
        $A.createComponent(
            "c:FuturoImpaginazioneComp", {
                
            },
            function(newCmp) {
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    },
   /**
   * @description: method go To FuturoClientePaginazione 
   * @date::16/03/2019
   * @author:Mady COLY
   * @modification: none
   */
    navigateToFuturoImpaginazioneComp: function (component, event, helper) {
        var loadData = event.getParam("loadData");
        if(component.get("v.mostraConttati")=="mostraChuisi")
        helper.fetchCommodities(component,true);
        helper.fetchCommodities(component,loadData);
    },

   /**
   * @description: method go To CommunityServeyDetail component 
   * @date::20/03/2019
   * @author:Mady COLY
   * @modification: none
   */
  navigateToCommunityServey: function (component, event, helper) {
    var clienteFuturoId=event.getParam('Id');
    var fromAmministrazione=event.getParam('fromAmministrazione');
       $A.createComponent(
           "c:ClienteFuturoDetail", {
               'Id':clienteFuturoId,
               'fromAmministrazione': fromAmministrazione
           },
           function(newCmp) {
               if (component.isValid()) {
                   component.set("v.body", newCmp);
               }
           }
       );
    },
    navigateToFuturoImpaginazioneCompByAgente: function(component, event, helper){
        helper.fetchCommoditiesByAgente(component,event);
      },
      /**
   * @description: method go To Administration
   * @date::04/06/2019
   * @author:Mame Seynabou Diop
   * @modification: none
   */
  navigateToAdministration: function(component, event, helper) {
    $A.createComponent(
        "c:FuturoAmmistrazionneCmp", {
            
        },
        function(newCmp) {
            if (component.isValid()) {
                component.set("v.body", newCmp);
            }
        }
    );
},

/**
   * @description: method go Administration to Agente
   * @date::11/06/2019
   * @author:Aminata GUEYE
   * @modification: none
   */
  navigateToAdministrationAgente: function(component, event, helper) {
    // Assign server method to action variable
	var action = component.get("c.getAllAgente");
	// caching data 
	action.setStorable();
	// Callback function to get the response
	action.setCallback(this, function(response) {
		// Getting the response state
		var state = response.getState();
		// Check if response state is success
		if(state === 'SUCCESS' && component.isValid()){
			var result=response.getReturnValue();
			if(result.error==true){
			var toastParams = {
				title: "Error",
				message: "Unknown error", // Default error message
				type: "error"
				};
			toastParams.message =result.message;
				var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams(toastParams);
			toastEvent.fire();
			}
			else{
			// Getting the list of client from response and storing in js variable
            var storeResponse = result.data;
            var mois=component.get("v.keyMonth");
            var annee=component.get("v.keyYear");
            var total=component.get("v.keyTotal");
            var dataFiltered = [];
            var object={};  
            var listChuisi=storeResponse;
             storeResponse=[];
            listChuisi.forEach(function(element) {
              var conforme=0;
            var nonConforme=0;
              if (Array.isArray(element.Commodity_Survey__r)) {
               (element.Commodity_Survey__r).forEach(function(element1){
                 if(element1.COM_PraticheChiuse_Conforme__c==1){
                 conforme+=(element1.COM_PraticheChiuse_Conforme__c);
                 }
                 if(element1.COM_ChiusoNon_Conforme__c==1){
                  nonConforme+=(element1.COM_ChiusoNon_Conforme__c);
                  }
                });
                }

              object= {sobjectType: "COM_Agente__c",Com_Area__c:element.Com_Area__c,Com_Codice__c:element.Com_Codice__c, Name:element.Name,Com_Numero_Contatti__c:element.Com_Numero_Contatti__c,
                Commodity_Survey__r:element.Commodity_Survey__r,CreatedDate:element.CreatedDate,COM_PraticheChiuse_Conforme__c:conforme,COM_ChiusoNon_Conforme__c:nonConforme };
                storeResponse.push(object);
                object={};
                console.log("Succes  ", storeResponse);
       
            });
            var monthNames = new Array("Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno",
"Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre");

            storeResponse.forEach(function(element){
              var dateFiltre=new Date(element.CreatedDate);
                var year= dateFiltre.getFullYear();
                var month = monthNames[dateFiltre.getMonth()];
            
                  if(month==mois && year==annee){
                    dataFiltered.push(element); 
                  }
                  console.log("dataFiltered  ", dataFiltered);
                });
                console.log("Succes datafilter ", dataFiltered);
                var dataSelect=[];
                if(total!="Totale")
                 dataSelect=dataFiltered;
                else{
                  var totale=[];
                  var agente = {
                    sobjectType: "COM_Agente__c",
                    Name: "Totale",
                    Com_Codice__c: "",
                    Com_Numero_Contatti__c: 0,
                    Commodity_Survey__r: [],
                    COM_ChiusoNon_Conforme__c:0,
                    COM_PraticheChiuse_Conforme__c:0
          
                  };
                  dataFiltered.forEach(function(element) {
                    agente.Com_Numero_Contatti__c += element.Com_Numero_Contatti__c;
                    agente.COM_PraticheChiuse_Conforme__c+=element.COM_PraticheChiuse_Conforme__c;
                    agente.COM_ChiusoNon_Conforme__c+=element.COM_ChiusoNon_Conforme__c;
                    if (Array.isArray(element.Commodity_Survey__r)) {
                    
                      Array.prototype.push.apply(
                        agente.Commodity_Survey__r,
                        element.Commodity_Survey__r
                      );
                    }
                    
                  });
                
                  totale.push(agente);
                  dataSelect=totale;
                }
                  $A.createComponent(
                      "c:FuturoImpaginazioneComp", {
                              'objectList':dataSelect,
                              'isFiltered': true
                      },
                      function(newCmp) {
                          if (component.isValid()) {
                              component.set("v.body", newCmp);
                          }
                      }
                        );          
        }		
		
		}
        else {
            console.log("errror: " + JSON.stringify(response));
          }
		
	});
	// Adding the action variable to the global action queue
	$A.enqueueAction(action);
},
getMonth: function(component, event, helper){
    var month = event.getParam('month'); 
   var year = event.getParam('year'); 
   var total=event.getParam('total');
   //Set the handler attributes based on event data 
component.set('v.keyMonth', month);
component.set('v.keyTotal', total);
component.set('v.keyYear', year);

},
    getButton: function(component, event, helper){
      var pratiche = event.getParam('praticheCliente'); 
      component.set('v.pratiche',pratiche);
     var mostraConttati = event.getParam('mostraConttati'); 
     component.set('v.mostraConttati', mostraConttati);

  
  },
})