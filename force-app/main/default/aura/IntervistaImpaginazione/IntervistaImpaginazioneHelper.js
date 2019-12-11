({
  /**
   * @description: method for fetch with order Filiali
   * @date::07/03/2019
   * @author:Salimata NGOM
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  onLoad: function(component, event, sortField) {
    //call apex class method
    var action = component.get("c.fetchFiliali");
    // pass the apex method parameters to action
    action.setParams({
      sortField: sortField,
      isAsc: component.get("v.isAsc")
    });
    action.setCallback(this, function(response) {
      //store state of response
      var state = response.getState();
      if (state === "SUCCESS") {
        //set response value in paginationList attribute on component.
        component.set("v.paginationList", response.getReturnValue());
      }
    });
    $A.enqueueAction(action);
  },

  /**
   * @description: method for retrieve All filiali
   * @date::05/03/2019
   * @author:Salimata NGOM
   * @params: component, event
   * @return: none
   * @modification:
   */
  doInit: function(component, event) {
    //init the current date
    try {
      component.set("v.currentDate", Date.parse(new Date()));
    } catch (e) {
      console.error(e);
    }
    
    component.set("v.SpinnerSearch", true);
    var nameFilialePratiche = "";
    if(component.get("v.loadData")==false){
            var curDate = component.get("v.currentDate");
            var data = component.get("v.objectList");
            console.log("List1", JSON.stringify(data));
            component.set("v.datafilialList", data);
            component.set("v.dataInitial", data);
            data = data.filter(
              row =>
                row.COM_Stato_Avanzamento_Intervista__c === "Nuovo" ||
                (row.COM_Stato_Avanzamento_Intervista__c === "Non Risponde" &&
                 row.COM_CRMRichiamare_il__c < curDate ) ||
                (row.COM_Stato_Avanzamento_Intervista__c === "Richiamare" &&
                  row.COM_CRMRichiamare_il__c < curDate)
            );
            component.set("v.objectList", data);
            component.set("v.dataByFiliali", []);
            //data = this.parseDateArray(data);
            this.initializePagination(component, null, data);
            component.set("v.filteredData", data);
    }
    else
    {
    if (component.get("v.Id")) {
      nameFilialePratiche = component.get("v.Id");
      console.log("nameFilialePratiche", nameFilialePratiche);
      component.set("v.dataName", nameFilialePratiche);
      component.set("v.codiceFiliale", "");
      this.runSearch(component, event);
    } else {
      var curDate = component.get("v.currentDate");
      var action = component.get("c.getAllInterviews");
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var data = response.getReturnValue();
          console.log("List1", JSON.stringify(data));
          data = this.parseDateArray(data);
          component.set("v.datafilialList", data);
          component.set("v.dataInitial", data);
          data = data.filter(
            row =>
              row.COM_Stato_Avanzamento_Intervista__c === "Nuovo" ||
             (row.COM_Stato_Avanzamento_Intervista__c === "Non Risponde" &&
              row.COM_CRMRichiamare_il__c < curDate)||
              (row.COM_Stato_Avanzamento_Intervista__c === "Richiamare" &&
                row.COM_CRMRichiamare_il__c < curDate) 
          );
          component.set("v.objectList", data);
          component.set("v.dataByFiliali", []);
          //data = this.parseDateArray(data);
          this.initializePagination(component, null, data);
          component.set("v.filteredData", data);
        }
      });
      $A.enqueueAction(action);
    }
  }
  
    // component.set("v.toggleSpinner", false);
  },

  /**
   * @description: method for set details of pagination filiali list
   * @date::05/03/2019
   * @author:Salimata NGOM
   * @params: component, datafiliali
   * @return: none
   * @modification:
   */
  PageDetails: function(component, recs) {
    var paginationList = [];
    for (var i = 0; i < recs.length; i++) {
      paginationList.push(recs[i]);
    }
    console.log(JSON.stringify(paginationList));
    component.set("v.paginationList", paginationList);
  },
  /**
   * @description: method for initalize pagination filiali list
   * @date::05/03/2019
   * @author:Salimata NGOM
   * @params: component,event, datafiliali
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
    var action = component.get("c.execQueryFilteredPratiche");
    action.setParams({
      NameFiliale: component.get("v.dataName"),
      codiceFiliale: component.get("v.codiceFiliale")
    });
    action.setCallback(this, function(actionResult) {
      if (action.getState() === "SUCCESS") {
        var objectList = actionResult.getReturnValue();
        objectList = this.parseDateArray(objectList);
        component.set("v.datafilialList", objectList);
        objectList = objectList.filter(
          row =>
            row.COM_Stato_Avanzamento_Intervista__c === "Nuovo" ||
            row.COM_Stato_Avanzamento_Intervista__c === "Richiamare"
        );
        component.set("v.filteredData", objectList);
        component.set("v.paginationList", objectList);
        this.initializePagination(component, null, objectList);
      } else if (action.getState() === "ERROR") {
        $A.log("Errors", action.getError());
      }
    });
    $A.enqueueAction(action);
  },
  /**
   * @description: method for convert Array Of Objects To excel
   * @date::08/03/2019
   * @author:Salimata NGOM
   * @params: component, objectRecords
   * @return: none
   * @modification:
   */
  convertArrayOfObjectsToCSV: function(component, objectRecords) 
  {
       // declare variables
       var csvStringResult,counter,keys,columnDivider,lineDivider,keysLabelName;

       // check if "objectRecords" parameter is null, then return from function
       if( objectRecords == null || !objectRecords.length ){
           return null;
       }
        
       // store ,[comma] in columnDivider variabel for sparate CSV values and
       // for start next line use '\n' [new line] in lineDivider varaible
       columnDivider = ",";
       lineDivider   = "\n";
       // in the keys variable store fields API Names as a key
       // this labels use in CSV file header
       keys = [
               "COM_CRMNome_Cliente_Formula__c",
               "COM_N_Telefono_Cel__c",
               /*"COM_date_first_contacted__c",*/"COM_Data_Esito__c",
               "COM_CRMNome_Filiale_Formula__c",
               "COM_D_liquid__c",
               "LastModifiedDate",
               "COM_C_prod__c",
               "COM_Ultimo_Esito_FIL__c",
               "COM_callback_notes__c",
               "Ritiro_Doc__c",
               "COM_cin_z_calc__c",
               "COM_Ultima_Modifica_Utente__c",
               "Contratto1__c",
               "Secci1__c",
               "Precontratto1__c",
               "Questionario_assicurativo1__c",
               "Contratto_Assicurazione__c",
               "Documenti_Assicurazione1__c",
               "Soddisfazione_Cliente1__c",
               "Count_Positivi__c",
               "Count_Negativi__c",
               "Valutazione__c",
               "COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c"
             ]; 
    
      keysLabelName = [
                          "CLIENTE",
                          "TELEFONO",
                          "DATA CONTATTO",
                          "FILIALE",
                          "DATA LIQUIDAZIONE",
                          "DATA ULTIMA MODIFICA",
                          "PRODOTTO",
                          "ULTIMO ESITO",
                          "NOTE",
                          "RITIRO DOC",
                          "CIN",
                          "UTENTE",
                          "CONTRATTO",
                          "SECCI",
                          "PRECONTRATTO",
                          "QUESTIONARIO ASSICURATIVO",
                          "CONTRATTO ASSICURAZIONE",
                          "DOC. ASSICURAZIONE",
                          "SODDISF. CLIENTE",
                          "COUNT POSITIVI",
                          "COUNT NEGATIVI",
                          "VALUTAZIONE",
                          "ATTIVITA' DI RECALL INTERNO POST COMMODITY"
                     ]; 
      
    csvStringResult = "";
    csvStringResult += keysLabelName.join(columnDivider);
    csvStringResult += lineDivider;
    for( var i = 0; i < objectRecords.length; i++ ) 
    {
         counter = 0;
         var extractedRec = objectRecords[i].Risposte__r;
         var dateMod = objectRecords[i]["LastModifiedDate"];
         var dateLiquid = objectRecords[i]["COM_D_liquid__c"];
         var dateUltimoEsito = objectRecords[i]["COM_Data_Esito__c"];
         if( dateMod != null ) 
         {
             dateMod = dateMod.split("T")[0];
             dateMod = dateMod.split("-").join("/");
         }else if( dateMod == undefined ) 
         {
             dateMod = " ";
         }
      
         if( dateLiquid != null ) 
         {
             dateLiquid = dateLiquid.split("-").join("/");
         }else if( dateLiquid == undefined )
         {
             dateLiquid = " ";
         }
        
         if( dateUltimoEsito != null )
         {
             dateUltimoEsito = dateUltimoEsito.split("-").join("/");
         }else if( dateUltimoEsito == undefined )
         {
             dateUltimoEsito = " ";
         }
      
         for( var sTempkey in keys )
         {
              var skey = keys[sTempkey];
              // add , [comma] after every String value,. [except first]
                 if( counter > 0 ) 
                 {
                     csvStringResult += columnDivider;
                 }
                 if( skey === "LastModifiedDate" ) 
                 {
                     csvStringResult += '"' + dateMod + '"';
                 }else if (skey === "COM_D_liquid__c")
                 {
                     csvStringResult += '"' + dateLiquid + '"';
                 }else if( skey === "COM_Data_Esito__c")
                 {
                     csvStringResult += '"' + dateUltimoEsito + '"';
                 }
                     
                     
                 else if (objectRecords[i][skey] == undefined) 
                 {
                     csvStringResult += " ";
                 }else{ 
                     csvStringResult += '"' + objectRecords[i][skey] + '"';
                 }
              
                 if(  skey === "Contratto1__c" || skey === "Secci1__c" || skey === "Precontratto1__c" 
                   || skey === "Questionario_assicurativo1__c" || skey === "Contratto_Assicurazione__c" 
                   || skey === "Documenti_Assicurazione1__c" || skey === "Soddisfazione_Cliente1__c" 
                   || skey === "Count_Positivi__c" || skey === "Count_Negativi__c" || skey === "Valutazione__c" )
                   {
                       
                       if( extractedRec == undefined )
                       {
                           csvStringResult += " ";
                       }else{
                              if( extractedRec[0][skey] == undefined)
                              {
                                  csvStringResult += " ";
                              }else{
                                  csvStringResult += '"' + extractedRec[0][skey] + '"';
                              }
                       }
                   }
              counter++;
             
      } // inner for loop close
      csvStringResult += lineDivider;
        //break;
    } // outer main for loop close
    // return the CSV formate String
    return csvStringResult;
  },
 
  sortHelper: function(component, event, sortFieldNumeroPratiche) {
    var currentDir = component.get("v.arrowDirection");

    if (currentDir == "arrowdown") {
      // set the arrowDirection attribute for conditionally rendred arrow sign
      component.set("v.arrowDirection", "arrowup");
      // set the isAsc flag to true for sort in Assending order.
      component.set("v.isAsc", true);
    } else {
      component.set("v.arrowDirection", "arrowdown");
      component.set("v.isAsc", false);
    }
    // call the onLoad function for call server side method with pass sortFieldName
    this.onLoad(component, event, sortFieldCliente);
  },
 
  getPraticheFilter: function(component, event, nameFiliali) {
    var action = component.get("c.execQueryFilteredPratiche");
    action.setParams({
      NameFiliale: nameFiliali,
      codiceFiliale: ""
    });
    action.setCallback(this, function(actionResult) {
      if (action.getState() === "SUCCESS") {
        this.initializePagination(
          component,
          null,
          actionResult.getReturnValue()
        );
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
  
  getSUMProdottoEV: function(component, stato, idfiliale) {
    // var Value = 0;

    var action = component.get("c.getSUMProdottoEV");
    action.setParams({
      IDFiliale: idfiliale,
      Prodotto: "EV"
    });
    action.setCallback(this, function(actionResult) {
      if (action.getState() === "SUCCESS") {
        return actionResult.getReturnValue();
      } else if (action.getState() === "ERROR") {
        $A.log("Errors", action.getError());
      }
    });
    $A.enqueueAction(action);
    //alert('----2:Value:'+Value);
    //return Value;
    /*
    var sumFirstNumber = 0;
    //alert( '24_04_2019 datafilialList.size()>>>'+ component.get("v.datafilialList").length );
    component.get("v.datafilialList").forEach(function(filiale) {
      if (
        filiale.COM_Stato_Avanzamento_Intervista__c == stato &&
        filiale.COM_C_prod__c == "EV" &&
        filiale.COM_MD_Filiale__c == idfiliale
      ) {
        sumFirstNumber = sumFirstNumber + 1;
      }
    });
    return sumFirstNumber; */
  },
  
  getSumConclusaIncorso: function(component, idfiliale, PROD, Param) {
    var sumConclusa = 0;
    var sumIncorso = 0;
    var datafilialList = component.get("v.datafilialList");

    component.get("v.datafilialList").forEach(function(filiale) {
      if (
        filiale.COM_Stato_Avanzamento_Intervista__c == "Nuovo" &&
        filiale.COM_MD_Filiale__c == idfiliale &&
        filiale.COM_Status__c == "Processing"
      ) {
        if (Param == 1 && filiale.COM_C_prod__c == PROD) {
          sumIncorso++;
        }
        /*
        if (Param == 2 && filiale.COM_C_prod__c !== PROD) {
          sumIncorso++;
        } */
      }
      console.log("sumConclusa", sumConclusa);
      console.log("sumIncorso", sumIncorso);
    });
    return sumIncorso;
  },
  getSumProcessingNONEV: function(component, idfiliale) {
    var sumConclusa = 0;
    var sumIncorso = 0;
    var datafilialList = component.get("v.datafilialList");

    component.get("v.datafilialList").forEach(function(filiale) {
      if (
        filiale.COM_Stato_Avanzamento_Intervista__c == "Nuovo" &&
        filiale.COM_MD_Filiale__c == idfiliale &&
        filiale.COM_Status__c == "Processing"
      ) {
        if (filiale.COM_C_prod__c !== "EV") {
          sumIncorso++;
        }
      }
      console.log("sumConclusa", sumConclusa);
      console.log("sumIncorso", sumIncorso);
    });
    return sumIncorso;
  },
  
  isCurrentDayBefore: function() {
    var now = new Date();
    var lastweek = new Date(now.getFullYear(), now.getMonth() + 1, -7);
    console.log("lastweek", lastweek);
    return now < lastweek;
  },

 FilterPratiche: function(component, event, Stato) {
    /** Call of Apex method that order by the records**/
    var action = component.get("c.getPraticheFiltrate");
    action.setParams({
      FiltroPratiche: Stato
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
    var objectList = component.get("v.objectList");
  },

  filterPrat: function(component, key) {
    var objectList = component.get("v.filteredData");
    var alternativeList = [];
    console.log("befor objectList ", objectList);
    if (key == null) {
      this.initializePagination(component, null, objectList);
    } else if (key == "NN") {
      alternativeList = Promise.resolve(
        this.excludeElentArray(objectList, "Nuovo")
      );
      alternativeList.then(function(list) {
        var pageSize = component.get("v.pageSize");
        component.set("v.start", 0);
        component.set("v.end", pageSize - 1);
        var totalPage = Math.ceil(list.length / pageSize);
        console.log("totalPage=" + totalPage);
        component.set("v.totalPage", totalPage);
        var pages = [];
        for (var i = 1; i <= totalPage; i++) {
          pages.push(i);
        }
        component.set("v.pages", pages);
        var paginationList = [];
        for (var i = 0; i < pageSize; i++) {
          if (list.length > i) paginationList.push(list[i]);
        }
        component.set("v.totalRecord", list.length);
        component.set("v.objectList", list);
        component.set("v.paginationList", paginationList);
        component.set("v.currentPage", 1);
        //this.PageDetails(component, paginationList);

        var paginationList2 = [];
        for (var i = 0; i < list.length; i++) {
          paginationList2.push(list[i]);
        }
        component.set("v.paginationList", paginationList2);
      });
    } else {
      /*Promise.resolve(
        (objectList = objectList.filter(
          row => row.COM_Stato_Avanzamento_Intervista__c == key
        ))
      ).then(() => this.initializePagination(component, null, objectList));*/
      alternativeList = Promise.resolve(this.filterArray(objectList, key));
      alternativeList.then(function(list) {
        //this.initializePagination(component, null, list);

        var pageSize = component.get("v.pageSize");
        component.set("v.start", 0);
        component.set("v.end", pageSize - 1);
        var totalPage = Math.ceil(list.length / pageSize);
        console.log("totalPage=" + totalPage);
        component.set("v.totalPage", totalPage);
        var pages = [];
        for (var i = 1; i <= totalPage; i++) {
          pages.push(i);
        }
        component.set("v.pages", pages);
        var paginationList = [];
        for (var i = 0; i < pageSize; i++) {
          if (list.length > i) paginationList.push(list[i]);
        }
        component.set("v.totalRecord", list.length);
        component.set("v.objectList", list);
        component.set("v.paginationList", paginationList);
        component.set("v.currentPage", 1);
        //this.PageDetails(component, paginationList);

        var paginationList2 = [];
        for (var i = 0; i < list.length; i++) {
          paginationList2.push(list[i]);
        }
        component.set("v.paginationList", paginationList2);
      });
    }
    //console.log('afterobjectList ', objectList);
  },

  sortArrayByDate: function(arrayToDisplay, date) {
    var list = [];
    date = Date.parse(date);
    arrayToDisplay.forEach(function(element, index) {
      if (element.COM_CRMRichiamare_il__c <= date) {
        list.unshift(element);
      } else {
        list.push(element);
      }
    });
    return list;
  },

  parseDateArray: function(data) {
    data.forEach(function(element, index) {
      element.COM_CRMRichiamare_il__c = Date.parse(
        element.COM_CRMRichiamare_il__c
      );
      data[index] = element;
    });

    return data;
  },

  wrappArray: function(data) {
    Promise.resolve((data = this.sortArrayByDate(date))).then(
      (data = this.parseDateArray(data))
    );
    return data;
  },

  filterArray: function(data, key) {
    //data = data.filter(row => row.COM_Stato_Avanzamento_Intervista__c == key);
    data = data.filter(row =>
      row.COM_Stato_Avanzamento_Intervista__c.toLowerCase().includes(
        key.toLowerCase()
      )
    );

    return data;
  },

  excludeElentArray: function(data, key) {
    data = data.filter(
      row =>
        !row.COM_Stato_Avanzamento_Intervista__c.toLowerCase().includes(
          key.toLowerCase()
        )
    );
    return data;
  },
  setKeyFilter: function(component, key, filterValue) {
    //var data = component.get("v.datafilialList");
    var dataByFiliali = component.get("v.dataByFiliali");
    var initialData = component.get("v.dataInitial");
    //var data = component.get("v.objectList");
    var data = component.get("v.filteredData");
    var dataTemp;
    //key = key.replace(/[^a-zA-Z0-9]/g, '');
    if ($A.util.isEmpty(key)) {
      console.log("key empty" + key);
      if (dataByFiliali.length == 0) {
        dataTemp = data;
      } else {
        dataTemp = dataByFiliali;
      }
      this.initializePagination(component, null, dataTemp);
    } else {
      console.log("key helpeerrr" + key);
      Promise.resolve(
        data.filter(function(row) {
          console.log("date row: " + row.COM_D_liquid__c);
          if (filterValue === "nomecliente") {
            if (row.COM_CRMNome_Cliente_Formula__c) {
              return row.COM_CRMNome_Cliente_Formula__c.toLowerCase().includes(
                key.toLowerCase()
              );
            }
          }
          if (filterValue === "telefono") {
            if (row.COM_N_Telefono_Cel__c) {
              return row.COM_N_Telefono_Cel__c.toLowerCase().includes(
                key.toLowerCase()
              );
            }
          }
          if (filterValue === "dateLiquidazione") {
            if (row.COM_D_liquid__c && key) return row.COM_D_liquid__c === key;
          }
          if (filterValue === "dataUltimaModifico") {
            console.log("LastModifiedDate :" + row.LastModifiedDate);
            var chars = row.LastModifiedDate.split("T");
            if (chars[0] && key) return chars[0] === key;
          }
          if (filterValue === "prodotto") {
            if (row.COM_C_prod__c) {
              return row.COM_C_prod__c.toLowerCase().includes(
                key.toLowerCase()
              );
            }
          }
          if (filterValue === "Filiali") {
            if (row.COM_MD_Filiale__r.Name) {
              return row.COM_MD_Filiale__r.Name.toLowerCase().includes(
                key.toLowerCase()
              );
            }
          }
          return false;
        })
      ).then(datas => {
        console.log("datas ", datas);
        this.initializePagination(component, null, datas);
      });
    }
  },

  filterByPromise: function(data, key, filterValue) {
    data = data.filter(function(row) {
      console.log("date row: " + row.COM_D_liquid__c);
      if (filterValue === "nomecliente") {
        if (row.COM_CRMNome_Cliente_Formula__c) {
          return row.COM_CRMNome_Cliente_Formula__c.toLowerCase().includes(
            key.toLowerCase()
          );
        }
      }
      if (filterValue === "telefono") {
        if (row.COM_N_Telefono_Cel__c) {
          return row.COM_N_Telefono_Cel__c.toLowerCase().includes(
            key.toLowerCase()
          );
        }
      }
      if (filterValue === "dateLiquidazione") {
        if (row.COM_D_liquid__c && key) return row.COM_D_liquid__c === key;
      }
      if (filterValue === "dataUltimaModifico") {
        console.log("LastModifiedDate :" + row.LastModifiedDate);
        var chars = row.LastModifiedDate.split("T");
        if (chars[0] && key) return chars[0] === key;
      }
      if (filterValue === "prodotto") {
        if (row.COM_C_prod__c) {
          return row.COM_C_prod__c.toLowerCase().includes(key.toLowerCase());
        }
      }

      if (filterValue === "Filiali") {
        if (row.COM_MD_Filiale__r.Name) {
          return row.COM_MD_Filiale__r.Name.toLowerCase().includes(
            key.toLowerCase()
          );
        }
      }
      return false;
    });
  },

  changeArrowDirection: function(component) {
    var currentDir = component.get("v.arrowDirection");
    if (currentDir == "arrowup") {
      console.log("arrowup-----");
      component.set("v.arrowDirection", "arrowdown");
    } else {
      component.set("v.arrowDirection", "arrowup");
      //ArrowCliente = "DESC";
    }
    console.log("camaraLaye");
  },

 
  sortByCliente: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    component.set("v.selectedTabsoft", "Cliente");
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a != null && b != null) {
        var t1 = a.COM_NomeCliente__r.Name == b.COM_NomeCliente__r.Name,
          t2 = a.COM_NomeCliente__r.Name < b.COM_NomeCliente__r.Name;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },
 
  sortByFiliale: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    component.set("v.selectedTabsoft", "Filiale");
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.COM_MD_Filiale__r.Name != null) {
        var t1 = a.COM_MD_Filiale__r.Name == b.COM_MD_Filiale__r.Name,
          t2 = a.COM_MD_Filiale__r.Name < b.COM_MD_Filiale__r.Name;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },
  
  sortByTelefono: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    component.set("v.selectedTabsoft", "Telefono");
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.COM_N_Telefono_Cel__c != null) {
        var t1 = a.COM_N_Telefono_Cel__c == b.COM_N_Telefono_Cel__c,
          t2 = a.COM_N_Telefono_Cel__c < b.COM_N_Telefono_Cel__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },
  
  sortByDataLiquidazione: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    component.set("v.selectedTabsoft", "DataLiquidazione");
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.COM_D_liquid__c != null) {
        var t1 = a.COM_D_liquid__c == b.COM_D_liquid__c,
          t2 = a.COM_D_liquid__c < b.COM_D_liquid__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },
  
  sortByDataContatto: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    component.set("v.selectedTabsoft", "DataContatto");
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.COM_date_first_contacted__c != null) {
        var t1 = a.COM_date_first_contacted__c == b.COM_date_first_contacted__c,
          t2 = a.COM_date_first_contacted__c < b.COM_date_first_contacted__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },
  
  sortByDataUltimaModifica: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    component.set("v.selectedTabsoft", "DataUltimaModifica");
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.LastModifiedDate != null) {
        var t1 = a.LastModifiedDate == b.LastModifiedDate,
          t2 = a.LastModifiedDate < b.LastModifiedDate;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },

  

  sortByUltimoEsito: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    component.set("v.selectedTabsoft", "UltimoEsito");
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.COM_Ultimo_Esito_FIL__c != null) {
        var t1 = a.COM_Ultimo_Esito_FIL__c == b.COM_Ultimo_Esito_FIL__c,
          t2 = a.COM_Ultimo_Esito_FIL__c < b.COM_Ultimo_Esito_FIL__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },

  //sort By Prodotto
  sortByProdotto: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    component.set("v.selectedTabsoft", "Prodotto");
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.COM_C_prod__c != null) {
        var t1 = a.COM_C_prod__c == b.COM_C_prod__c,
          t2 = a.COM_C_prod__c < b.COM_C_prod__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },
  
  sortByRichiamareIl: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    component.set("v.selectedTabsoft", "Richiamareil");
    //currentList = this.parseDateArray(currentList);
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.COM_CRMRichiamare_il__c != null) {
        var t2 = a.COM_CRMRichiamare_il__c < b.COM_CRMRichiamare_il__c;
        return t2 ? 0 : t2 ? 1 : -1;
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },

  
  sortByNote: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.COM_callback_notes__c != null) {
        var t1 = a.COM_callback_notes__c == b.COM_callback_notes__c,
          t2 = a.COM_callback_notes__c < b.COM_callback_notes__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },
  sortByRitiroDoc: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    component.set("v.selectedTabsoft", "RitiroDoc");
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.Ritiro_Doc__c != null) {
        var t1 = a.Ritiro_Doc__c == b.Ritiro_Doc__c,
          t2 = a.Ritiro_Doc__c < b.Ritiro_Doc__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },

  
  sortByCINZ: function(component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    component.set("v.selectedTabsoft", "CIN");
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.COM_cin_z_calc__c != null) {
        var t1 = a.COM_cin_z_calc__c == b.COM_cin_z_calc__c,
          t2 = a.COM_cin_z_calc__c < b.COM_cin_z_calc__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  },
          
  sortByColumn: function(component, column) 
  {
      var currentOrder  = component.get("v.isAsc"),
          currentList   = component.get("v.objectList");

      if( column === "Cliente" ){
          component.set("v.selectedTabsoft","Cliente");
      }else if( column === "Telefono" ){
          component.set("v.selectedTabsoft","Telefono")
      }else if( column === "Prodotto" ){
          component.set("v.selectedTabsoft","Prodotto")
      }else if( column === "DataContatto" ){
          component.set("v.selectedTabsoft","DataContatto");
      }else if( column === "Filiale"){
          component.set("v.selectedTabsoft","Filiale");
      }else if( column === "DataUltimaModifica"){
          component.set("v.selectedTabsoft","DataUltimaModifica");
      }else if( column === "Richiamareil"){
          component.set("v.selectedTabsoft","Richiamareil");
      }else if( column === "RitiroDoc"){
          component.set("v.selectedTabsoft","RitiroDoc")
      }else if( column === "DataLiquidazione"){
          component.set("v.selectedTabsoft","DataLiquidazione");
      }else if( column === "CIN"){
          component.set("v.selectedTabsoft","CIN");
      }else if( column === "UltimoEsito"){
          component.set("v.selectedTabsoft","UltimoEsito");
      }
      
      currentOrder = !currentOrder;
      currentList.sort( function(a, b) 
      {
          if( a != null && b != null ) 
          {
              var FirstCell = "";
              var SecondCell = "";
                  if( column === "Cliente" ) 
                  {
                      FirstCell  = a.COM_NomeCliente__r.Name;
                      SecondCell = b.COM_NomeCliente__r.Name;
                  }else if( column === "Telefono")
                  {
                      FirstCell  = a.COM_N_Telefono_Cel__c;
                      SecondCell = b.COM_N_Telefono_Cel__c;
                  }else if( column === "Prodotto")
                  {
                      FirstCell  = a.COM_C_prod__c;
                      SecondCell = b.COM_C_prod__c;    
                  }else if( column === "DataContatto")
                  {
                      FirstCell  = a.COM_date_first_contacted__c;
                      SecondCell = b.COM_date_first_contacted__c;
                  }else if( column === "Filiale")
                  {
                      FirstCell  = a.COM_MD_Filiale__r.Name;
                      SecondCell = b.COM_MD_Filiale__r.Name;
                  }else if( column === "DataUltimaModifica")
                  {
                      FirstCell  = a.LastModifiedDate;
                      SecondCell = b.LastModifiedDate;
                  }else if( column === "Richiamareil")
                  {
                      FirstCell  = a.COM_CRMRichiamare_il__c;
                      SecondCell = b.COM_CRMRichiamare_il__c;
                  }else if( column === "RitiroDoc")
                  {
                      FirstCell  = a.Ritiro_Doc__c;
                      SecondCell = b.Ritiro_Doc__c;
                  }else if( column === "DataLiquidazione")
                  {
                      FirstCell  = a.COM_D_liquid__c;
                      SecondCell = b.COM_D_liquid__c;
                  }else if( column === "CIN")
                  {
                      FirstCell  = a.COM_cin_z_calc__c;
                      SecondCell = b.COM_cin_z_calc__c;
                  }else if( column === "UltimoEsito")
                  {
                      FirstCell  = a.COM_Ultimo_Esito_FIL__c;
                      SecondCell = b.COM_Ultimo_Esito_FIL__c;
                  }
              var t1 = FirstCell == SecondCell, //a.COM_NomeCliente__r.Name == b.COM_NomeCliente__r.Name,
                  t2 = FirstCell < SecondCell; //a.COM_NomeCliente__r.Name < b.COM_NomeCliente__r.Name;
        
              return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
           }
        return true;
    } );

    this.changeArrowDirection(component);

    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, event, component.get("v.objectList"));
  }
});