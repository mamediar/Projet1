({
  /**
   * @description: method for retrieve All filiali
   * @date::15/05/2019
   * @author:Aminata GUEYE
   * @params: component, event
   * @return: none
   * @modification:
   */
  doInit: function(component, event) {
    var dataF= event.getParam('dataF');
    console.log('dataF recu de event', dataF);
    try {
      var action = component.get("c.getAllAgente");
      //action.setStorable();
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var result = response.getReturnValue();
          console.log("Result: ", result);
          if (result.error == true) {
            alert("Errorrrrr");
            console.log("In error apex: ", result.message);
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
            
            var object={};
            var storeResponse = response.getReturnValue().data;
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
                Commodity_Survey__r:element.Commodity_Survey__r,COM_PraticheChiuse_Conforme__c:conforme,COM_ChiusoNon_Conforme__c:nonConforme };
                storeResponse.push(object);
                object={};
                console.log("Succes  ", storeResponse);
       
            });
         
            component.set("v.agenteList", storeResponse);
            component.set("v.objectList", storeResponse);
            console.log("Succes data ", storeResponse);
            this.initializePagination(component, null, storeResponse);
          }
        } else {
          console.log("errror: " + JSON.stringify(response));
        }
      });
      $A.enqueueAction(action);
    } catch (e) {
      console.log("errror: " + JSON.stringify(e));
    }
  },
  sortCodiceAgenteHelper: function( component,event,helper)
  {
        component.set("v.selectedTabsoft", "CodiceAgente");
        var currentDir = component.get("v.arrowDirection");
        var list       = component.get("v.objectList");

        var byCodiceAgente   = list.slice(0);
        if( currentDir == "arrowup" ) 
        {
            
            byCodiceAgente.sort(function(a, b) 
            {
                 var x = a.Com_Codice__c; 
                 var y = b.Com_Codice__c; 
                 return x - y;
            });
            component.set("v.arrowDirection", "arrowdown");
        }else{
            
           byCodiceAgente.sort(function(a, b) 
           {
                 var x = a.Com_Codice__c; 
                 var y = b.Com_Codice__c; 
                 return y - x;
           });
           component.set("v.arrowDirection", "arrowup");
       }
       this.initializePagination(component, event, byCodiceAgente);
  
      
  },
  sortAgenteHelper: function( component,event,helper )
  {
        
    var currentOrder = component.get("v.isAsc"),
    currentList = component.get("v.objectList");
  currentOrder = !currentOrder;
  currentList.sort(function (a, b) {
    if (a.Name != null && b.Name!= null) {
      var t1 = a.Name == b.Name,
        t2 = a.Name < b.Name;
      return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
    }
    return true;
  });
  this.changeArrowDirection(component);
  component.set("v.isAsc", currentOrder);
  component.set("v.objectList", currentList);
  this.initializePagination(component,null, component.get("v.objectList"));
  },
  changeArrowDirection: function (component) {
    //console.log("fleche");
    var currentDir = component.get("v.arrowDirection");
    if (currentDir == "arrowup") {
      //console.log("arrowup-----");
      component.set("v.arrowDirection", "arrowdown");
    } else {
     // console.log("arrowDown-----");
      component.set("v.arrowDirection", "arrowup");
      //ArrowCliente = "DESC";
    }
  },
  sortTargetHelper: function( component,event,helper)
  {
        component.set("v.selectedTabsoft", "target");
        var currentDir = component.get("v.arrowDirection");
        var list       = component.get("v.objectList");

        var byTarget   = list.slice(0);
      
        if( currentDir == "arrowup" ) 
        {
            byTarget.sort(function(a, b) 
            {
                 var x = a.Com_Numero_Contatti__c; 
                 var y = b.Com_Numero_Contatti__c; 
                 return x - y;
            });
            component.set("v.arrowDirection", "arrowdown");
        }else{
           byTarget.sort(function(a, b) 
           {
                 var x = a.Com_Numero_Contatti__c; 
                 var y = b.Com_Numero_Contatti__c; 
                 return y - x;
           });
           component.set("v.arrowDirection", "arrowup");
       }
       this.initializePagination(component, event, byTarget);
  },
  sortNumeroPraticheHelper: function( component,event,helper)
  {
        component.set("v.selectedTabsoft", "numeroPratiche");
        var currentDir       = component.get("v.arrowDirection");
        var list             = component.get("v.objectList");
        
        var byNumeroPratiche = list.slice(0);
       
        if( currentDir == "arrowup" ) 
        {
            byNumeroPratiche.sort(function(a, b) 
            {
                 var x = a.Commodity_Survey__r
                   ? a.Commodity_Survey__r.length
                   : 0; 
                 var y = b.Commodity_Survey__r
                   ? b.Commodity_Survey__r.length
                   : 0; 
                 return x - y;
            });
            component.set("v.arrowDirection", "arrowdown");
        }else{
           byNumeroPratiche.sort(function(a, b) 
           {
                 var x = a.Commodity_Survey__r ? a.Commodity_Survey__r.length : 0; 
                 var y = b.Commodity_Survey__r
                   ? b.Commodity_Survey__r.length
                   : 0; 
                 return y - x;
           });
           component.set("v.arrowDirection", "arrowup");
        }
        this.initializePagination(component, event, byNumeroPratiche);
        
  },
  sortChiusoConformeHelper: function( component,event,helper)
  {
        component.set("v.selectedTabsoft", "chiusoconforme");
        var currentDir       = component.get("v.arrowDirection");
        var list             = component.get("v.objectList");
        
        var byChiusoConforme = list.slice(0);
        
        if( currentDir == "arrowup" ) 
        {
            byChiusoConforme.sort(function(a, b) 
            {
                 var x = a.COM_PraticheChiuse_Conforme__c; 
                 var y = b.COM_PraticheChiuse_Conforme__c; 
                 return x - y;
            });
            component.set("v.arrowDirection", "arrowdown");
        }else{
           byChiusoConforme.sort(function(a, b) 
           {
                 var x = a.COM_PraticheChiuse_Conforme__c; 
                 var y = b.COM_PraticheChiuse_Conforme__c; 
                 return y - x;
           });
           component.set("v.arrowDirection", "arrowup");
        }
        this.initializePagination(component, event, byChiusoConforme);
       
  },
  sortChiusoNonConformeHelper: function( component,event,helper)
  {
        component.set("v.selectedTabsoft", "chiusononconforme"); 
        var list                = component.get("v.objectList");
        var currentDir          = component.get("v.arrowDirection");
      
        var byChiusoNonConforme = list.slice(0);
        if( currentDir == "arrowup" ) 
        {
          byChiusoNonConforme.sort(function(a, b) 
            {
                 var x = a.COM_ChiusoNon_Conforme__c; 
                 var y = b.COM_ChiusoNon_Conforme__c; 
                 return x - y;
            });
            component.set("v.arrowDirection", "arrowdown");
        }else{
          byChiusoNonConforme.sort(function(a, b) 
           {
                 var x = a.COM_ChiusoNon_Conforme__c; 
                 var y = b.COM_ChiusoNon_Conforme__c; 
                 return y - x;
           });
           component.set("v.arrowDirection", "arrowup");
        }
        this.initializePagination(component, event, byChiusoNonConforme);
  },
  /**
   * @description: method for set details of pagination agente list
   * @date::15/05/2019
   * @author:Aminata GUEYE
   * @params: component, dataagente
   * @return: none
   * @modification:
   */
  PageDetails: function(component, recs) {
    var paginationList = [];
    for (var i = 0; i < recs.length; i++) {
      paginationList.push(recs[i]);
    }
    component.set("v.paginationList", paginationList);
  },
  /**
   * @description: method for initalize pagination agente list
   * @date::15/05/2019
   * @author:Aminata GUEYE
   * @params: component,event, dataagente
   * @return: none
   * @modification:
   */
  initializePagination: function(component, event, recs) {
    var pageSize = component.get("v.pageSize");
    component.set("v.start", 0);
    component.set("v.end", pageSize - 1);
    var totalPage = Math.ceil(recs.length / pageSize);
    console.log("totalPage=" + totalPage);
    component.set("v.totalPage", totalPage);
    var pages = [];
    for (var i = 1; i <= totalPage; i++) {
      pages.push(i);
    }
    component.set("v.pages", pages);
    var paginationList = [];
    for (var i = 0; i < pageSize; i++) {
      if (recs.length > i) paginationList.push(recs[i]);
    }
    component.set("v.totalRecord", recs.length);
    component.set("v.objectList", recs);
    component.set("v.paginationList", paginationList);
    component.set("v.currentPage", 1);
    this.PageDetails(component, paginationList);
  },
  /**
   * @description: method for run search
   * @date::05/03/2019
   * @author:Salimata NGOM
   * @params: component, event
   * @return: none
   * @modification:
   */
  runSearch: function(component, event) {
    var action = component.get("c.execQueryFiltered");
    console.log("NameFiliale", component.get("v.dataName"));
    console.log("codiceFiliale", component.get("v.codiceFiliale"));
    console.log("chiusoConforme", component.get("v.chiusoConforme"));
    console.log("chiusoNonConforme", component.get("v.chiusoNonConforme"));
    action.setParams({
      NameFiliale: component.get("v.dataName"),
      codiceFiliale: component.get("v.codiceFiliale"),
      numeroPratiche: component.get("v.numeroPratiche"),
      chiusoConforme: component.get("v.chiusoConforme"),
      chiusoNonConforme: component.get("v.chiusoNonConforme")
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        this.initializePagination(component, null, response.getReturnValue());
        console.log("actionResult.getReturnValue()", response.getReturnValue());
      } else {
        $A.log("Errors", action.getError());
      }
    });
    $A.enqueueAction(action);
  },
  // Same logic of search
  handleFilter: function(data, key, fieldName) {
    var regex;
    try {
      regex = new RegExp(key, "i");
      data = data.filter(function(row) {
        return row.fieldName.toLowerCase().includes(key.toLowerCase());
      });
    } catch (e) {
      console.error(e);
    }
    return data;
  },
  sortHelper: function(component, event, column) {
    /**Column to Order**/
    var ColumnToOrder = "";
    if (column === "Filiale") {
      component.set("v.selectedTabsoft", "Filiale");
      ColumnToOrder = "COM_NomeCliente__r.Name";
    }

    /** Direction of Column to Order **/
    var currentDir = component.get("v.arrowDirection");
    var ArrowCliente = "";
    if (currentDir == "arrowup") {
      console.log("arrowup-----");
      component.set("v.arrowDirection", "arrowdown");
      ArrowCliente = "ASC";
    } else {
      component.set("v.arrowDirection", "arrowup");
      ArrowCliente = "DESC";
    }

    /** Call of Apex method that order by the records**/
    var action = component.get("c.getAllInterviewsOrderBy");
    action.setParams({
      FieldToOrderBy: ColumnToOrder,
      TypeOfOrder: ArrowCliente
    });
    action.setCallback(this, function(actionResult) {
      if (action.getState() === "SUCCESS") {
        console.log("--------------Risultato---------------");
        console.log(actionResult.getReturnValue());
        this.initializePagination(
          component,
          null,
          actionResult.getReturnValue()
        );
        //this.initializePagination(component, null ,actionResult.getReturnValue());
      } else if (action.getState() === "ERROR") {
        $A.log("Errors", action.getError());
      }
    });
    $A.enqueueAction(action);
  },
  showToast: function(message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      message: message,
      type: type
    });
    toastEvent.fire();
  },
  visualizzaPer: function(component, key) {
    if (key == "Agente") {
      this.initializePagination(component, null, component.get("v.agenteList"));
    } else if (key == "Totale") {
      var totale = component.get("v.totale");
      if (!totale.length) {
        console.log("first recupération");
        var agente = {
          sobjectType: "COM_Agente__c",
          Name: "Totale",
          Com_Codice__c: "",
          Com_Numero_Contatti__c: 0,
          Commodity_Survey__r: [],
          COM_ChiusoNon_Conforme__c:0,
          COM_PraticheChiuse_Conforme__c:0

        };
        var data = component.get("v.objectList");
        console.log("les données totales"+JSON.stringify(data));
        data.forEach(function(element) {
          agente.Com_Numero_Contatti__c += element.Com_Numero_Contatti__c;
          agente.COM_PraticheChiuse_Conforme__c+=element.COM_PraticheChiuse_Conforme__c;
          agente.COM_ChiusoNon_Conforme__c+=element.COM_ChiusoNon_Conforme__c;
          if (Array.isArray(element.Commodity_Survey__r)) {
            /* agente.Commodity_Survey__r.concat(
              element.Commodity_Survey__r
            ); */
            Array.prototype.push.apply(
              agente.Commodity_Survey__r,
              element.Commodity_Survey__r
            );
          }
          
        });
        console.log("agente recupération", agente);
        /* totale[0] = agente; */
        totale.push(agente);
        component.set("v.totale", totale);
        this.initializePagination(component, null, totale);
      } else {
        console.log('déjà recupéré');
        this.initializePagination(component, null, totale);
      }
    }
  },
  filterClienteByAgente : function(component,agente){
    
  },
  navigateToFuturoImpaginazioneComp: function(component,event){
    var interviewPosition = event.target.getAttribute("data-index");
    var interviewCurrentObj = component.get("v.paginationList")[interviewPosition];
    var evt = $A.get("e.c:eventNavigateToFuturoImpaginazioneCompByAgente");
        evt.setParams({
          "agenteId": interviewCurrentObj.Id
      });
      evt.fire();     
  },
});