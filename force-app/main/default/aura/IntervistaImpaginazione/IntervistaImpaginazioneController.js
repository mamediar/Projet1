({
  
  init: function(component, event, helper) {
    helper.doInit(component, event);
    //component.set("v.SpinnerSearch", true);
  },
  
  setValueFilter: function(component, event, helper) {
    var key = component.find("namefiliale").get("v.value");
    console.log("key cnt " + key);
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

  setValueDataContattoFilter: function(component, event, helper) {
    var key = component.find("dataContatto").get("v.value");
    helper.setKeyFilter(component, key, "dataContatto");
  },

  setValuedataUltimaModificaFilter: function(component, event, helper) {
    var key = component.find("dataUltimaModifico").get("v.value");
    helper.setKeyFilter(component, key, "dataUltimaModifico");
  },

  setValueProdottoFilter: function(component, event, helper) {
    var key = component.find("prodotto").get("v.value");
    helper.setKeyFilter(component, key, "prodotto");
  },
  
  getRunSearch: function(component, event, helper) {
    var dataName = component.find("namefiliale").get("v.value");
    if (dataName == "") {
      helper.initializePagination(
        component,
        null,
        component.get("v.datafilialList")
      );
      component.set("v.SpinnerSearch", true);
    } else {
      helper.runSearch(component, event);
      component.set("v.SpinnerSearch", true);
    }
  },

  filterAssicurativos: function(component, event, helper) {
    //console.log("------------------04_04_2019----------------------");
    var data = component.get("v.datafilialList");
    //alert(data.length);
    console.log('data fi', JSON.stringify(data));

    //console.log("12_04_2019 data depart", JSON.stringify(data));

    var select = document.getElementById("status");
    var key = select.options[select.selectedIndex].value;
    var curDate = new Date();//component.get("v.currentDate");
    curDate = curDate.setMinutes(curDate.getMinutes());
    var statusKey = "",
      statusKey1 = "",
      statusKey4 = "",
      statusKey2 = "";
    try {
      switch (key) {
        /*case "Tutte le pratiche":
          // helper.filterPrat(component, null);
          helper.doInit();
          // data = data.filter(row => row.COM_Stato_Avanzamento_Intervista__c ===  "");
          break;*/

        case "Pratiche liquidate":
          component.set('v.choiceColorPratiche','rgb(245, 190, 195)');
          //alert(data.length);
          data = data.filter(
            row =>
              row.COM_Stato_Avanzamento_Intervista__c === "Nuovo" ||
              row.COM_Stato_Avanzamento_Intervista__c === "Richiamare"
              (row.COM_Stato_Avanzamento_Intervista__c === "Non Risponde" &&
               row.COM_CRMRichiamare_il__c < curDate ) ||
              (row.COM_Stato_Avanzamento_Intervista__c ===
                "Richiamare" &&
                row.COM_CRMRichiamare_il__c < curDate)
          );
          console.log("data FR 1", JSON.stringify(data));
          //helper.FilterPratiche( component , event , 'N');
          // helper.filterPrat(component, "Nuovo");
          //alert(data.length);
          break;
        //if( FiltroPratiche == 'NN')ConditionOnStato = ' WHERE COM_Stato_Avanzamento_Intervista__c != \'Nuovo\' ';
        case "Contatti utili chiusi":
          component.set('v.choiceColorPratiche',"none");
          statusKey = "Conclusa";
          data = data.filter(
            row =>
              row.COM_Stato_Avanzamento_Intervista__c == "" + statusKey &&
              row.COM_Interview_Utils__c == true
          );
              console.log("data FR 2", JSON.stringify(data));

          //helper.FilterPratiche( component , event , 'C');
          // helper.filterPrat(component, "Conclusa");
          break;
        case "Tutti i contatti eseguiti":
          component.set('v.choiceColorPratiche',"none");
          statusKey = "Nuovo";
          data = data.filter(
            row => row.COM_Stato_Avanzamento_Intervista__c !== "" + statusKey
          );
          console.log("data FR 3", JSON.stringify(data));


          //helper.FilterPratiche(component, event, 'NN');
          // helper.filterPrat(component, "NN");
          break;
        case "Richiami":
          component.set('v.choiceColorPratiche',"none");
          statusKey  = "Non Risponde";
          statusKey1 = "Richiamare";
          data = data.filter(
            row => row.COM_Stato_Avanzamento_Intervista__c === "" + statusKey ||
                   row.COM_Stato_Avanzamento_Intervista__c === "" + statusKey1
          );
          console.log("data FR 4", JSON.stringify(data));

          //helper.FilterPratiche( component , event , 'R');
          // helper.filterPrat(component, "Richiamare");
          break;
        case "Contatti negativi":
          component.set('v.choiceColorPratiche',"none");
          statusKey  = "Conclusa";
          statusKey4 = "NEGATIVO";
        //statusKey1 = "Non accetta";
        //statusKey2 = "Irreperibile";
          data = data.filter(
            row =>
               row.COM_Stato_Avanzamento_Intervista__c === "" + statusKey/* || 
                row.COM_Stato_Avanzamento_Intervista__c === "" + statusKey1 ||
                row.COM_Stato_Avanzamento_Intervista__c === "" + statusKey2*/ &&
              row.Risposte__r != undefined && row.Risposte__r[0] != undefined && row.Risposte__r[0]["Valutazione__c"] != undefined &&
              row.COM_Interview_Utils__c === false 
          );
          
          //alert('11/07/2019 data[0]:'+data[0].COM_Stato_Avanzamento_Intervista__c);
          //alert('11/07/2019 data[0]:---'+data[0].Risposte__r[0]["Valutazione__c"]); 
          
          //helper.FilterPratiche( component , event , 'NG');
          // helper.filterPrat(component, "Non Risponde");
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
    helper.initializePagination(component, null, component.get("v.objectList"));
    data = [];
  },

  sortClienteFiliali: function(component, event, helper) {
    var ClienteParam = "Cliente";
    helper.sortByColumn(component,"Cliente");
  },
    
  sortProdottoFiliali: function(component, event, helper) {
    var ProdottoParam = "Prodotto";
    helper.sortByColumn(component,"Prodotto");
    //helper.sortByProdotto(component);
  },
    
  sortTelefonoFiliali: function(component, event, helper) {
    var TelefonoParam = "Telefono";
    helper.sortByColumn(component,"Telefono");
    //helper.sortByTelefono(component);
  },
    
  sortDataContatto: function(component, event, helper) {
    var DataContattoParam = "DataContatto";
    helper.sortByColumn(component,"DataContatto");
    //helper.sortByDataContatto(component);
  },
    
  sortFiliale: function(component, event, helper) {
    var FilialeParam = "Filiale";
    helper.sortByColumn(component,"Filiale");
    //helper.sortByFiliale(component);
  },
    
  sortByDataUltimaModificaParam: function(component, event, helper) {
    var DataUltimaModificaParam = "DataUltimaModifica";
    helper.sortByColumn(component,"DataUltimaModifica");
    //helper.sortByDataUltimaModifica(component);
  },

  sortByRichiamareil: function(component, event, helper) {
    var RichiamareilParam = "Richiamareil";
    helper.sortByColumn(component,"Richiamareil");
    //helper.sortByRichiamareIl(component);
  },

  sortByRitiroDoc: function(component, event, helper) {
    var RitiroDocParam = "RitiroDoc";
    helper.sortByColumn(component,"RitiroDoc");
    //helper.sortByRitiroDoc(component);
  },

  sortByDataLiquidazione: function(component, event, helper) {
    var DataLiquidazioneParam = "DataLiquidazione";
    helper.sortByColumn(component,"DataLiquidazione");
    //helper.sortByDataLiquidazione(component);
  },

  sortByCIN: function(component, event, helper) {
    var CINParam = "CIN";
    helper.sortByColumn(component,"CIN");
    //helper.sortByCINZ(component);
  },
    
  sortByUltimoEsito: function(component, event, helper) {
    var UltimoEsitoParam = "UltimoEsito";
    helper.sortByColumn(component,"UltimoEsito");
    //helper.sortByUltimoEsito(component);
  },
  
  downloadCsv: function(component, event, helper) 
  {
      // get the Records [Filiali] list from 'paginationList' attribute
      var stockData = component.get("v.objectList");
      if( stockData.length === 0 )
      {
          helper.showToast('Non ci sono record da scaricare!','ERROR');
          return;
      }
      
      var csv = helper.convertArrayOfObjectsToCSV(component, stockData);
      if (csv == null) return;

      // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
      var hiddenElement = document.createElement("a");
      hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
      hiddenElement.target = "_self"; //
      hiddenElement.download = "ExportData_Filiali.csv"; // CSV file Name* you can change it.[only name not .csv]
      document.body.appendChild(hiddenElement); // Required for FireFox browser
      hiddenElement.click(); // using click() js function to download csv file
  },
 
  redirect: function(component, event, helper) {
      
    var eventGoFiliali = $A.get("e.c:eventNavigateToFiliali");
    eventGoFiliali.fire();
  },
  
  PraticheImpaginazioneCompController: function(component, event, helper) {
    component.set("v.SpinnerSearch", true);

    //set attribute IdIntervista of event
    console.log("15_03_2019");
    var InterviewPosition = event.target.getAttribute("data-index");
    var InterviewCurrentObj = component.get("v.paginationList")[
      InterviewPosition
    ];
    //console.log('12_03_2019 InterviewCurrentObj://'+InterviewCurrentObj+'----InterviewCurrentObj.Id:::'+InterviewCurrentObj.Id);
    //dataset.index;
    console.log(
      "29_03_2019 InterviewCurrentObj: " +
        InterviewCurrentObj.COM_Stato_Avanzamento_Intervista__c
    );
    if( InterviewCurrentObj.COM_Status__c === "Processing" )
    {
          helper.showToast(
                           "Non è possibile procedere,la pratica è in lavorazione",
                           "WARNING"
                          );
    } else {
      switch( InterviewCurrentObj.COM_Stato_Avanzamento_Intervista__c ) 
      {
              case "In corso":
                                console.log("Im inside");
                                helper.showToast(
                                                   "Non è possibile procedere,il cliente è bloccato",
                                                   "WARNING"
                                                );
                    break;
        
              case "Nuovo":
                    
                    //alert('InterviewCurrentObj.COM_Stato_Avanzamento_Intervista__c->'+InterviewCurrentObj.COM_Stato_Avanzamento_Intervista__c);
                    if( InterviewCurrentObj.COM_C_prod__c == "EV" )
                    {
                        var firstNumber = InterviewCurrentObj.COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c;
                        //helper.getSUMProdottoEV(component,"In Corso",InterviewCurrentObj.COM_MD_Filiale__c);
                        //var firstNumber = helper.getSumProductoEV(component,"In corso",InterviewCurrentObj.COM_MD_Filiale__c);
                        console.log("firstnumber", firstNumber);
                        var secondNumber = helper.getSumConclusaIncorso(component,InterviewCurrentObj.COM_MD_Filiale__c,'EV',1);
                        console.log("secondNumber", secondNumber);
                        //alert('controller secondNumber::'+secondNumber);
                        if( secondNumber === undefined)secondNumber = 0;
                        
                        var sumFirstNumberSecondNumber = firstNumber+secondNumber;
                        //alert('firstNumber::'+firstNumber);
                        //alert('secondNumber::'+secondNumber);
                        //alert('sumFirstNumberSecondNumber->'+sumFirstNumberSecondNumber);
                        
                        
                        if (firstNumber + secondNumber >= 2) 
                        {
                            helper.showToast("Numero di Interviste EV raggiunto per la filiale","WARNING");
                        } //Fixed: 29_03_2019: Orlando.S
                        else {
                             
                           var evt = $A.get("e.c:eventNavigateToIntervistaDettagli");
                           evt.setParams({
                                            Id: InterviewCurrentObj.Id,
                                            data : component.get("v.datafilialList")
                                         });
                           evt.fire();
                       }
                    } else {
                      var CurrentDayBefore = helper.isCurrentDayBefore();
                      //alert('CurrentDayBefore->'+CurrentDayBefore);
                      if (helper.isCurrentDayBefore()) 
                      {
                          //alert('-----------------------------------------------------');
                          console.log("prod(isCurrentDayBefore)",InterviewCurrentObj.COM_C_prod__c);
                          var FirstNumberNONEV = InterviewCurrentObj.COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c;

                          var SecondNumberNONEVInCorso = helper.getSumProcessingNONEV( component , InterviewCurrentObj.COM_MD_Filiale__c );
                              
                              //helper.getSumConclusaIncorso(component,InterviewCurrentObj.COM_MD_Filiale__c,'EV',2);
                          //alert('Controller FirstNumberNONEV->'+FirstNumberNONEV);
                          //alert('Controller SecondNumberNONEVInCorso->'+SecondNumberNONEVInCorso);
                          
                          
                          if( /*helper.getSumConclusaIncorso(component,InterviewCurrentObj.COM_MD_Filiale__c)*/ FirstNumberNONEV+SecondNumberNONEVInCorso>= 8 ) 
                          {
                              helper.showToast("Numero di interviste NON EV raggiunto per la filiale","WARNING");
                          }else{
                              
                             var evt = $A.get("e.c:eventNavigateToIntervistaDettagli");
                                  evt.setParams({Id: InterviewCurrentObj.Id,  data : component.get("v.datafilialList")});
                                  evt.fire();
                          }
                     } else { 
                         console.log("prod(isCurrentDayBefore else)",InterviewCurrentObj.COM_C_prod__c);
                        var FirstNumberNONEV = InterviewCurrentObj.COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c;

                         var SumConclusaInCorso = helper.getSumProcessingNONEV( component , InterviewCurrentObj.COM_MD_Filiale__c );
                             
                        //helper.getSumConclusaIncorso(component,InterviewCurrentObj.COM_MD_Filiale__c,'EV',2);
                        if(FirstNumberNONEV+SumConclusaInCorso >=10) 
                        {
                           helper.showToast("Numero di interviste raggiunto per la Filiale","WARNING");
                        }//Fixed: 29_03_2019: Orlando.S
                        else {
                             
                                 var evt = $A.get("e.c:eventNavigateToIntervistaDettagli");
                                 evt.setParams({
                                                 Id: InterviewCurrentObj.Id,
                                                 data : component.get("v.datafilialList")
                                               });
                                 evt.fire();
                        }
            }
          }
          break;
        default:
          // helper.getSumProductoNotEV(component,'EV');
          //console.log('currentDate',lastDay);
          var evt = $A.get("e.c:eventNavigateToIntervistaDettagli");
          evt.setParams({
            Id: InterviewCurrentObj.Id,
            data : component.get("v.datafilialList")
          });
          evt.fire();
          break;
      }
    }
  },
    
  getPraticheFilter: function(component, event, helper) {
    console.log("---01_04_2019---");
  }
    
    
});