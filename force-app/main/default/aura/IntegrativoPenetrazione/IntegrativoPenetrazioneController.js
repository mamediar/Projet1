({
    init : function(component,event, helper) {
      helper.doInit(component);
     //console.log('Arrivée initializePagination');
      
        
    },

    intervistaDetail: function(component, event, helper) {
      var index = event.target.getAttribute("data-index");
      var InterviewCurrentObj = component.get("v.paginationList")[
        index
      ];
      //console.log("intervi select: "+InterviewCurrentObj)
  
      var productsLimites = component.get("v.productsLimites");
      //console.log('productsLimites >>>>> ',productsLimites);
      var toastEvent = $A.get("e.force:showToast");
        //impossible to start the interview
      var IntervistaIntegrativo =  InterviewCurrentObj;
        if (IntervistaIntegrativo.Status__c == "Processing") {
            //blocked interview
            //component.set("v.AvivoIntervista", false);
            //show message
            toastEvent.setParams({
                title: "Warning",
                type: "warning",
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
                //component.set("v.AvivoIntervista", false);
                //show message
                toastEvent.setParams({
                    title: "Warning",
                    type: "warning",
                    message: "Non e possibile procedere, il limite mensile raggiunto."
                });
                toastEvent.fire();
            } else {
              var evt = $A.get("e.c:eventNavigateToIntervistaPenetrazioneDetails");
              evt.setParams({
                intervistaPenetrazione: InterviewCurrentObj,
                productsLimites:productsLimites
              });
              evt.fire();
            }
        }
       
      
      
    },

    downloadCsv: function(component,event, helper) {
        // get the Records list from 'paginationList' attribute
        var stockData = component.get("v.dataIntervistaList");
        // call the helper function which "return" the CSV data as a String
        if( stockData.length === 0 )
        {
            helper.showToast('Non ci sono record da scaricare!','ERROR');
            return;
        }
        stockData.forEach(function(element) {
          if(element.Stato__c == 'vuoto'){
            element.Stato__c ='';
          }
          if(element.Status__c == 'Processing'){
            element.Stato__c ='';
          }
        });
        
       //console.log("11_07_2019 stockData::" + stockData[0][0]);
        var csv = helper.convertArrayOfObjectsToCSV(component, stockData);
        if (csv == null) {
          return;
        }
    
        var hiddenElement = document.createElement("a");
        hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
        hiddenElement.target = "_self"; //
        hiddenElement.download = "ExportDataIntegrativoPenetrazione.csv"; // CSV file Name* you can change it.[only name not .csv]
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },

    downloadCsvAllChiuse : function(component,event,helper){

        var stockData = component.get("v.dataIntervistaList");
       //console.log('stockData :'+JSON.stringify(stockData));
        var data=[];
        stockData.forEach(function(element) {
        if(element.Stato__c == "Conclusa" )
          data.push(element);
        });
       //console.log('data :'+JSON.stringify(data));
        if( data.length === 0 )
        {
            helper.showToast('Non ci sono record da scaricare!','ERROR');
            return;
        }
       //console.log("11_07_2019 stockData::" + stockData[0][0]);
        var csv = helper.convertArrayOfObjectsToCSV(component, data);
        if (csv == null) {
          return;
        }
    
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
        var hiddenElement = document.createElement("a");
        hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
        hiddenElement.target = "_self"; //
        hiddenElement.download = "ExportDataIntegrativoPenetrezione.csv"; // CSV file Name* you can change it.[only name not .csv]
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    /**
    * @description: method for set value to filter Prodotto
    * @date::07/06/2019
    * @author:Aminata GUEYE
    * @modification: NONE
    */    
   filtraPerData: function(component, event, helper) {
    var dateDA = component.find("idDateDA").get("v.value");
    var dateA = component.find("idDateA").get("v.value");
    var data=[];
    if((component.get("v.loadFilterList").length==0)){
   data=component.get("v.dataInitial");
      }
   else{  data = component.get("v.loadFilterList");
   }

    data = data.filter(row =>
      helper.isDatebetween(row.Data_Liquidazione__c, dateDA, dateA)
    );
    helper.initializePagination(component, data);
    data = [];
},
    /**
* @description: method for set value to filter Prodotto
* @date::12/06/2019
* @author:Aminata GUEYE
* @modification: NONE
*/
setValueFilter: function(component, event, helper) {
helper.setValueFilterHelper(component,event,helper);
 },
    filterByInputData:function(component,event,helper){
       helper.doFilter(component);   
    },

    sortCliente: function(component, event, helper) {
      helper.sortByCliente(component);
    },

    sortTelephono: function(component, event, helper) {
      component.set("v.sortField", "Telefono");
      helper.sortByTelefono(component);
    },

    sortDataContatto: function(component, event, helper) {
      component.set("v.sortField", "DataContatto");
      helper.sortByDataContatto(component);
    },
    
    sortIntermediario: function(component, event, helper) {
      component.set("v.sortField", "Intermediario");
      helper.sortByIntermediario(component);
    },

    sortUtente: function(component, event, helper) {
      component.set("v.sortField", "Utente");
      helper.sortByUtente(component);
    },
    
    sortDataLiquidazione: function(component, event, helper) {
      component.set("v.sortField", "DataLiquidazione");
      helper.sortByDataLiquidazione(component);
    },

    sortDataUltimaModifica: function(component, event, helper) {
      component.set("v.sortField", "DataUltimaModifica");
      helper.sortByDataUltimaModifica(component);
    },

    sortProdotto: function(component, event, helper) {
      component.set("v.sortField", "Prodotto");
      helper.sortByProdotto(component);
    },

    sortUltimoEsito: function(component, event, helper) {
      component.set("v.sortField", "UltimoEsito");
      helper.sortByUltimoEsito(component);
    },

    sortRichiamareIl: function(component, event, helper) {
      component.set("v.sortField", "RichiamareIl");
      helper.sortByRichiamareIl(component);
    },

    sortNote: function(component, event, helper) {
      component.set("v.sortField", "Note");
      helper.sortByNote(component);
    },
    filterIntervista: function(component, event, helper) {
      var data = component.get("v.dataIntervistaList");
      var select = document.getElementById("status");
      var dateColor = component.get("v.dateColor");
      var key = select.options[select.selectedIndex].value;
      var limitedIntermediario = component.get("v.limitedIntermediario");
      console.log('data to filter >> ', data);
      console.log('key to filter >> ', key);
      var statusKey = "",
        statusKey1 = "",
        statusKey2 = "";
      try {
        switch (key) {
          case "Pratiche liquidate":
              component.set("v.Richiami", false);
              helper.doInit(component);
            break;
         
          case "Tutti i contatti eseguiti":
            component.set("v.Richiami", true);
            statusKey = "vuoto";
           //console.log('data >>>', data);
            data = data.filter(
              row =>
               ( row.Stato__c ===
                  "Richiamare" ||
                row.Stato__c ===
                  "Conclusa" ||
                row.Stato__c ===
                  "Non accetta" ||
                row.Stato__c ===
                  "Irreperibile" ||
                row.Stato__c ===
                  "Non risponde") && 
               (row.Status__c ==="Archived" &&
               row.COM_Current_Period__c==true)
            );
           //console.log('data <<<', data);
            break;
          case "Richiami":
            component.set("v.Richiami", true);
            statusKey  = "Richiamare";
            data = helper.filterLimitedIntermediario(limitedIntermediario, data);
            data = data.filter(
              row =>
              ( ( row.Stato__c ===statusKey ||
                row.Stato__c === "Non accetta" ||
                row.Stato__c === "Non risponde") &&
                row.Status__c !="Archived")
            );
            break;
          default:
            statusKey = "";
            break;
        }

      } catch (e) {}

      console.log('data filtered >> ', data);
      component.set("v.loadFilterList", data);
      if(key != 'Pratiche liquidate'){
        helper.initializePagination(component, data);
      }
    data = [];
    },
    esclusioni: function(component, event, helper){
      var eventToNavigate = $A.get("e.c:eventNavigateToEsclusioni");
      eventToNavigate.fire();  
    }
})