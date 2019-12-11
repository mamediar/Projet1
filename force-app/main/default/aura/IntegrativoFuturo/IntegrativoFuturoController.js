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
    
    var productsLimites = component.get("v.productsLimites");
    //console.log('productsLimites', JSON.stringify(productsLimites));
    //console.log('productsLimites limitFuturo', productsLimites.limitFuturo);
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
          ////console.log('Teste limite Plc_Tipo_Prodotto__c:>>>', IntervistaIntegrativo.Plc_Tipo_Prodotto__c);
          ////console.log('Teste limite:>>>', productsLimites[IntervistaIntegrativo.Plc_Tipo_Prodotto__c]);
          if (productsLimites.limitFuturo) {
              //blocked interview
              //show message
              toastEvent.setParams({
                  title: "Warning",
                  type: "warning",
                  message: "Non e possibile procedere, il limite mensile raggiunto."
              });
              toastEvent.fire();
          } else {
            var evt = $A.get("e.c:eventNavigateToIntervistaFuturoDetails");
            evt.setParams({
              intervistaFuturo: InterviewCurrentObj,
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
      var dataToCsv = [];
      stockData.forEach(function(element) {
        if(element.Stato__c == 'vuoto'){
          element.Stato__c ='';
        }
        dataToCsv.push(element);
      });
      if( dataToCsv.length === 0 )
      {
          helper.showToast('Non ci sono record da scaricare!','ERROR');
          return;
      }
      var csv = helper.convertArrayOfObjectsToCSV(component, dataToCsv);
      if (csv == null) {
        return;
      }
  
      var hiddenElement = document.createElement("a");
      hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
      hiddenElement.target = "_self"; //
      hiddenElement.download = "ExportDataIntegrativoFuturo.csv"; // CSV file Name* you can change it.[only name not .csv]
      document.body.appendChild(hiddenElement); // Required for FireFox browser
      hiddenElement.click(); // using click() js function to download csv file
  },

  downloadCsvAllChiuse : function(component,event,helper){

      var stockData = component.get("v.dataIntervistaList");
      var data=[];
      stockData.forEach(function(element) {
      if(element.Stato__c == "Conclusa" )
        data.push(element);
      });
      if( data.length === 0 )
      {
          helper.showToast('Non ci sono record da scaricare!','ERROR');
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
      hiddenElement.download = "ExportDataIntegrativoFuturo.csv"; // CSV file Name* you can change it.[only name not .csv]
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
    var key = select.options[select.selectedIndex].value;
    var curDate = new Date();
    curDate = curDate.setMinutes(curDate.getMinutes() + 30);
    console.log('data >>', data);
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
          console.log('data tutti >>', data);
          break;
        case "Richiami":
          component.set("v.Richiami", true);
          statusKey  = "Richiamare";
          data = data.filter(
            row =>
            ( ( row.Stato__c ===statusKey ||
              row.Stato__c === "Non accetta" ||
              row.Stato__c === "Non risponde") &&
              row.Status__c !="Archived")
          );
          console.log('data richiame >>', data);
          break;
        default:
          statusKey = "";
          break;
      }

    } catch (e) {}
    component.set("v.loadFilterList", data);
    if(key != 'Pratiche liquidate'){
      helper.initializePagination(component, data);
    }
    //console.log('deet >>>', deet);
    //console.log('COM_Richiamare_il__c ', data[0].COM_Richiamare_il__c);
    //console.log('COM_Richiamare_il__c Date ', new Date(data[0].COM_Richiamare_il__c));
  data = [];
  },
  esclusioni: function(component, event, helper){
    //console.log('navigate to esclusioni page');
    var eventToNavigate = $A.get("e.c:eventNavigateToEsclusioni");
    //var evtEsclusioni = $A.get("e.c:eventNavigateToEsclusioni");
    //var evtEsclusioni = component.getEvent("esclusioniEvent");
    ////console.log('evtEsclusioni >>', evtEsclusioni);
    //console.log('eventToNavigate >>', eventToNavigate);
    eventToNavigate.fire();  
    //console.log('event fired >>');
  }
})