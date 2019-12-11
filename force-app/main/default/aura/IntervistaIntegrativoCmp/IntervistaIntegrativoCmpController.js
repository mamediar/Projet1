({
  init: function(component, event, helper) {
    helper.doInit(component);
    /* var dataIntervistaList = component.get('dataIntervistaList');
    var objectList = component.get('objectList');
    if(objectList){
     //console.log('données existent déjà :>>>>', objectList);
    }else{
      helper.doInit(component);
    } */
    
    //helper.getIntervisteDelmeseByProduct(component);
  },

  intervistaDetail: function(component, event, helper) {
    var index = event.target.getAttribute("data-index");
    var InterviewCurrentObj = component.get("v.paginationList")[index];
    //console.log("intervi select: "+InterviewCurrentObj)

    var productsLimites = component.get("v.productsLimites");
    //console.log('productsLimites >>>>> ',productsLimites);
    var toastEvent = $A.get("e.force:showToast");
    //impossible to start the interview
    var IntervistaIntegrativo = InterviewCurrentObj;
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
    } else if (IntervistaIntegrativo.Status__c == "New") {
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
        var evt = $A.get("e.c:eventNavigationIntervista");
        evt.setParams({
          IntervistaIntegrativo: InterviewCurrentObj,
          productsLimites: productsLimites
        });
        evt.fire();
      }
    }
  },

  downloadCsv: function(component, event, helper) {
    // get the Records list from 'paginationList' attribute
    var stockData = component.get("v.objectList");
    // call the helper function which "return" the CSV data as a String
    if (stockData.length === 0) {
      helper.showToast("Non ci sono record da scaricare!", "ERROR");
      return;
    }
    var csv = helper.convertArrayOfObjectsToCSV(component, stockData);
    if (csv == null) {
      return;
    }

    var hiddenElement = document.createElement("a");
    hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
    hiddenElement.target = "_self"; //
    hiddenElement.download = "ExportDataIntervistaIntegrativo.csv"; // CSV file Name* you can change it.[only name not .csv]
    document.body.appendChild(hiddenElement); // Required for FireFox browser
    hiddenElement.click(); // using click() js function to download csv file
  },

  downloadCsvAllChiuse: function(component, event, helper) {
    var stockData = component.get("v.dataIntervistaList");
    var data = [];
    stockData.forEach(function(element) {
      if (element.Stato__c == "Conclusa") data.push(element);
    });
    if (data.length === 0) {
      helper.showToast("Non ci sono record da scaricare!", "ERROR");
      return;
    }
    var csv = helper.convertArrayOfObjectsToCSV(component, data);
    if (csv == null) {
      return;
    }

    // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
    var hiddenElement = document.createElement("a");
    hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
    hiddenElement.target = "_self"; //
    hiddenElement.download = "ExportDataIntervistaIntegrativo.csv"; // CSV file Name* you can change it.[only name not .csv]
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
    helper.setValueFilterHelper(component, event, helper);
  },
  filterByInputData: function(component, event, helper) {
    helper.doFilter(component);
  },

  sortCliente: function(component, event, helper) {
    helper.sortByCliente(component);
  },
  sortIntermediario: function(component, event, helper) {
    helper.sortByIntermediario(component);
  },

  sortTelephono: function(component, event, helper) {
    component.set("v.sortField", "Telefono");
    helper.sortByTelefono(component);
  },

  sortDataContatto: function(component, event, helper) {
    component.set("v.sortField", "DataContatto");
    helper.sortByDataContatto(component);
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
    var key = select.options[select.selectedIndex].value;
    var curDate = new Date();
    curDate = curDate.setMinutes(curDate.getMinutes() + 30);
    var statusKey = "",
      statusKey1 = "",
      statusKey2 = "";
    try {
      switch (key) {
        case "Pratiche liquidate":
          component.set("v.Richiami", false);
          data = data.filter(
            row =>
              (row.Stato__c === "vuoto" ||
                (row.Stato__c === "Non risponde" &&
                  row.COM_Richiamare_il__c < component.get("v.curDate")) ||
                (row.Stato__c === "Richiamare" &&
                  row.COM_Richiamare_il__c < component.get("v.curDate")) ||
                (row.Stato__c === "Non accetta" &&
                  row.COM_Richiamare_il__c < component.get("v.curDate"))) &&
              row.Status__c != "Archived"
          );
          break;

        case "Tutti i contatti eseguiti":
          component.set("v.Richiami", true);
          statusKey = "vuoto";
          data = data.filter(
            row =>
              (row.Stato__c === "Richiamare" ||
                row.Stato__c === "Conclusa" ||
                row.Stato__c === "Non accetta" ||
                row.Stato__c === "Irreperibile" ||
                row.Stato__c === "Non risponde") &&
              (row.Status__c === "Archived"  && row.COM_Current_Period__c == true )
          );
          break;
        case "Richiami":
          component.set("v.Richiami", true);
          statusKey = "Richiamare";
          data = data.filter(
            row =>
              (row.Stato__c === statusKey ||
                row.Stato__c === "Non accetta" ||
                row.Stato__c === "Non risponde") &&
              row.Status__c != "Archived"
          );
          break;
        default:
          statusKey = "";
          break;
      }
    } catch (e) {}
    component.set("v.loadFilterList", []);
    component.set("v.loadFilterList", data);
    helper.initializePagination(component, data);
    data = [];
  }
});