({
 

  init: function(component, event, helper) {
    helper.doInit(component, event);
  },

 
  setValueFilter: function(component, event, helper) {
    //set input value to attribute
    if (document.getElementById("namefiliale").value != "") {
      var valuenamefiliale = document.getElementById("namefiliale").value;
      component.set("v.dataName", valuenamefiliale);
    } else if (document.getElementById("codiceFiliale").value != "") {
      var valuecodicefiliale = document.getElementById("codiceFiliale").value;
      component.set("v.codiceFiliale", valuecodicefiliale);
    } else if (document.getElementById("numeroPratiche").value != "") {
      var valuenumeroPratiche = document.getElementById("numeroPratiche").value;
      component.set("v.numeroPratiche", valuenumeroPratiche);
    } else if (document.getElementById("chiusoConforme").value != "") {
      var valuechiusoConforme = document.getElementById("chiusoConforme").value;
      component.set("v.chiusoConforme", valuechiusoConforme);
    } else if (document.getElementById("chiusoNonConforme").value != "") {
      var valuechiusoNonConforme = document.getElementById("chiusoNonConforme")
        .value;
      component.set("v.chiusoNonConforme", valuechiusoNonConforme);
    } else {
      //is empty refresh default list with initializePagination
      helper.initializePagination(component,component.get("v.datafilialList")
      );
    }
  },
  setValueFilter: function(component, event, helper) {
    var key = component.find("namefiliale").get("v.value");
    helper.setKeyFilter(component, key, "Filiali");
  },

  setValueNomeFilter: function(component, event, helper) {
    var key = component.find("nomecliente").get("v.value");
    helper.setKeyFilter(component, key, "nomecliente");
  },
  setValueTelefonoFilter: function(component, event, helper) {
    var key = component.find("telefono").get("v.value");
    helper.setKeyFilter(component, key, "telefono");
  },
  setValueDateLiquidazioneFilter: function(component, event, helper) {
    var key = component.find("dateLiquidazione").get("v.value");
    helper.setKeyFilter(component, key, "dateLiquidazione");
  },
  setValuedataUltimaModificaFilter: function(component, event, helper) {
    var key = component.find("dataUltimaModifico").get("v.value");
    helper.setKeyFilter(component, key, "dataUltimaModifico");
  },
  setValueDataContattoFilter: function(component, event, helper) {
    var key = component.find("dataContatto").get("v.value");
    helper.setKeyFilter(component, key, "dataContatto");
  },

  
  getRunSearch: function(component, event, helper) {
    if (
      document.getElementById("namefiliale").value === "" &&
      document.getElementById("codiceFiliale").value === "" &&
      document.getElementById("numeroPratiche").value === "" &&
      document.getElementById("chiusoConforme").value === "" &&
      document.getElementById("chiusoNonConforme").value === ""
    ) {
      helper.initializePagination(component,component.get("v.datafilialList")
      );
      component.set("v.SpinnerSearch", true);
    } else {
      helper.runSearch(component, event);
      component.set("v.SpinnerSearch", true);
    }
  },
 
  showSpinner: function(component, event, helper) {
    component.set("v.toggleSpinner", true);
  },
 
  hideSpinner: function(component, event, helper) {
    component.set("v.toggleSpinner", false);
  },
 
  sortNumeroPratiche: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.
    component.set("v.selectedTabsoft", "numeroPratiche");
    // call the helper function with pass sortField numeroPratiche
    helper.sortHelper(
      component,
      event,
      "COM_Filiale__r.COM_NumeroTotali_Pratiche__c"
    );
  },
 
  downloadCsv: function(component, event, helper) {
    // get the Records [Filiali] list from 'paginationList' attribute
    var stockData = component.get("v.objectList");
    // call the helper function which "return" the CSV data as a String
    if( stockData.length === 0 )
    {
        helper.showToast('Non ci sono record da scaricare!','ERROR');
        return;
    }
    //console.log("11_02_2019 stockData::" + stockData[0][0]);
    var csv = helper.convertArrayOfObjectsToCSV(component, stockData);
    if (csv == null) {
      return;
    }

    // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
    var hiddenElement = document.createElement("a");
    hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
    hiddenElement.target = "_self"; //
    hiddenElement.download = "ExportData Assicurativo.csv"; // CSV file Name* you can change it.[only name not .csv]
    document.body.appendChild(hiddenElement); // Required for FireFox browser
    hiddenElement.click(); // using click() js function to download csv file
  },
  downloadCsvAllChiuse : function(component,event,helper){

    var stockData = component.get("v.datafilialList");
    //console.log('stockData :'+JSON.stringify(stockData));
    var data=[];
    stockData.forEach(function(element) {
      //console.log('ultimo :'+element.COM_Stato_Avanzamento_IntervistaASS__c)
      if(element.COM_Stato_Avanzamento_IntervistaASS__c == "Conclusa" && element.Com_Current_Period_Assicurativo__c==true)
      data.push(element);
    });
    //console.log('data :'+JSON.stringify(data));
    if( data.length === 0 )
    {
        helper.showToast('Non ci sono record da scaricare!','ERROR');
        return;
    }
    //console.log("11_02_2019 stockData::" + stockData[0][0]);
    var csv = helper.convertArrayOfObjectsToCSV(component, data);
    if (csv == null) {
      return;
    }

    // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
    var hiddenElement = document.createElement("a");
    hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
    hiddenElement.target = "_self"; //
    hiddenElement.download = "ExportData Assicurativo.csv"; // CSV file Name* you can change it.[only name not .csv]
    document.body.appendChild(hiddenElement); // Required for FireFox browser
    hiddenElement.click(); // using click() js function to download csv file
  },

  filterAssicurativos: function(component, event, helper) {
    var data = component.get("v.datafilialList");
      
    var datatutticontatti = component.get("v.dataTuttiContatti");  
      
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
            component.set('v.choiceColorPratiche','rgb(245, 190, 195)');
          //statusKey = 'Nuovo';
          // data = data.filter(row => row.COM_Stato_Avanzamento_IntervistaASS__c === "" + statusKey);
          data = data.filter(
            row =>
              row.COM_Stato_Avanzamento_IntervistaASS__c === "Nuovo" || 
              row.COM_Stato_Avanzamento_IntervistaASS__c === "Non Risponde" ||
              (row.COM_Stato_Avanzamento_IntervistaASS__c ===
                "Richiamare" &&
                row.COM_CRMRichiamare_ilASS__c < curDate)
          );
          break;
        /*case "Contatti utili chiusi":
          statusKey = "Conclusa";
          data = data.filter(
            row =>
              row.COM_Stato_Avanzamento_IntervistaASS__c ==
                "" + statusKey &&
              row.Com_Current_Period_Assicurativo__c == true
          );*/
          /*statusKey = '';
                    data = data.filter(row => row.COM_Stato_Avanzamento_IntervistaASS__c === "" + statusKey);*/
          //break;
        case "Tutti i contatti eseguiti":
          component.set('v.choiceColorPratiche',"none");
          statusKey = "Nuovo";
          //alert('datatutticontatti.length-'+datatutticontatti.length+'--data.length-'+data.length);
          datatutticontatti = datatutticontatti.filter(
            row =>
              row.COM_Stato_Avanzamento_IntervistaASS__c ===
                "Richiamare" ||
              row.COM_Stato_Avanzamento_IntervistaASS__c ===
                "Conclusa" ||
              row.COM_Stato_Avanzamento_IntervistaASS__c ===
                "Non accetta" ||
              row.COM_Stato_Avanzamento_IntervistaASS__c ===
                "Irreperibile" ||
              row.COM_Stato_Avanzamento_IntervistaASS__c ===
                "Non Risponde"
          );
          data = [];
          data = datatutticontatti;
          break;
        case "Richiami":
            component.set('v.choiceColorPratiche',"none");
          statusKey  = "Richiamare";
          statusKey1 = "Non Risponde";
          data = data.filter(
            row =>
              row.COM_Stato_Avanzamento_IntervistaASS__c ===
              "" + statusKey || row.COM_Stato_Avanzamento_IntervistaASS__c === "" + statusKey1
          );
          break;
        case "Contatti negativi":
            component.set('v.choiceColorPratiche',"none");
          //statusKey1 = "Non accetta";
          statusKey2 = "Irreperibile";
          data = data.filter(
            row =>
              row.COM_Stato_Avanzamento_IntervistaASS__c ===
                "" + statusKey2
          );
          break;
        default:
          statusKey = "";
          statusKey1 = "";
          statusKey2 = "";
          break;
      }
    } catch (e) {}
    component.set("v.objectList", []);
    component.set("v.objectList", data);
    helper.initializePagination(component,component.get("v.objectList"));
    data = [];
  },

  assicurativoDetail: function(component, event, helper) {
    //set attribute assicurativoPosition of event
    var InterviewPosition = event.target.getAttribute("data-index");
    var intervista = component.get("v.nuovaIntervista");
    var InterviewCurrentObj = component.get("v.paginationList")[
      InterviewPosition
    ];
    //check if statos=New and update to Progressing

    var intervista = InterviewCurrentObj;
    if( intervista.COM_Status_ASS__c === 'Processing' )
    {
        helper.showToast(
                           "Non è possibile procedere,la pratica è in lavorazione",
                           "WARNING"
                          );
      
    }else if (intervista.COM_Status_ASS__c === "New") 
    {
      intervista.COM_Status_ASS__c  = "Processing";
      intervista.COM_Provenienza__c = "A";
      var action = component.get("c.updateIntervista");
      action.setParam("param", intervista);
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          console.log("update COM_Status_ASS__c=Processing success");
        }
      });
      $A.enqueueAction(action);
              console.log(
              "15_03_2019 InterviewCurrentObj://" +
                InterviewCurrentObj +
                "----InterviewCurrentObj.Id:::" +
                InterviewCurrentObj.Id
            );
            var evt = $A.get("e.c:eventNavigationAssicurativo");
            evt.setParams({
              Id: InterviewCurrentObj.Id
            });
            evt.fire();  
        
        
    }else if (intervista.COM_Status_ASS__c === "Archived")
    {
        var evt = $A.get("e.c:eventNavigationAssicurativo");
            evt.setParams({
              Id: InterviewCurrentObj.Id
            });
            evt.fire();  
    }
    
  },
 
  filtraPerData: function(component, event, helper) {
    var dateDA = component.find("idDateDA").get("v.value");
    var dateA = component.find("idDateA").get("v.value");

    var data = component.get("v.datafilialList");

    data = data.filter(row =>
      helper.isDatebetween(row.COM_D_liquid__c, dateDA, dateA)
    );

    // console.log('data is between', helper.isDatebetween(row.COM_D_liquid__c,dateDA,dateA));

    // if(!(data.length ==0)){
    component.set("v.objectList", []);
    component.set("v.objectList", data);
    helper.initializePagination(component,component.get("v.objectList"));
    // }

    data = [];
  },
 
  sortCliente: function(component, event, helper) {
    helper.sortByCliente(component);
  },

  sortFiliale: function(component, event, helper) {
    component.set("v.sortField", "Filiale");
    helper.sortByFiliale(component);
  },
 
    
  sortTelephono: function(component, event, helper) {
    component.set("v.sortField", "Telefono");
    helper.sortByTelefono(component);
  },
 
    
  sortDataLiquidazione: function(component, event, helper) {
    component.set("v.sortField", "DataLiquidazione");
    helper.sortByDataLiquidazione(component);
  },
 
  sortDataContatto: function(component, event, helper) {
    component.set("v.sortField", "DataContatto");
    helper.sortByDataContatto(component);
  },
  
  sortDataUltimaModifica: function(component, event, helper) {
    component.set("v.sortField", "DataUltimaModifica");
    helper.sortByDataUltimaModifica(component);
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
  
  sortCINZ: function(component, event, helper) {
    component.set("v.sortField", "CINZ");
    helper.sortByCINZ(component);
  }
});