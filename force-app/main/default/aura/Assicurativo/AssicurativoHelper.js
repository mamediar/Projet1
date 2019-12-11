({
  onLoad: function (component, event, sortField) {
    //call apex class method
    var action = component.get("c.fetchFiliali");

    // pass the apex method parameters to action
    console.log("sortfield" + sortField);
    action.setParams({
      sortField: sortField,
      isAsc: component.get("v.isAsc")
    });
    action.setCallback(this, function (response) {
      //store state of response
      var state = response.getState();
      if (state === "SUCCESS") {
        //set response value in paginationList attribute on component.
        component.set("v.paginationList", response.getReturnValue());
      }
    });
    $A.enqueueAction(action);
  },
    
  handleFilter: function () {
    var data = component.get("v.paginationList");
    var select = document.getElementById("status");
    var key = select.options[select.selectedIndex].value;
    var statusKey = "",
      statusKey1 = "",
      statusKey2 = "";
    try {
      switch (key) {
        case "Pratiche liquidate":
          statusKey = "Nuovo";
          data = data.filter(
            row => row.COM_Stato_Avanzamento_Intervista__c === statusKey
          );
          break;

        case "Contatti utili chiusi":
          statusKey = "";
          data = data.filter(
            row => row.COM_Stato_Avanzamento_Intervista__c === statusKey
          );
          break;
        case "Tutti i contatti eseguiti":
          statusKey = "Conclusa";
          data = data.filter(
            row => row.COM_Stato_Avanzamento_Intervista__c === statusKey
          );
          break;
        case "Richiami":
          statusKey = "Richiamare";
          data = data.filter(
            row => row.COM_Stato_Avanzamento_Intervista__c === statusKey
          );
          break;
        case "contatti negativi":
          statusKey1 = "Non accetta";
          statusKey2 = "Irreperibile";
          data = data.filter(
            row =>
              row.COM_Stato_Avanzamento_Intervista__c === statusKey1 ||
              row.COM_Stato_Avanzamento_Intervista__c === statusKey2
          );
          break;
        default:
          statusKey = "";
          statusKey1 = "";
          statusKey2 = "";
          break;
      }
    } catch (e) { }
    return data;
  },

  parseDateArray: function (data) {
    data.forEach(function (element, index) {
      if (element.COM_CRMRichiamare_il__c)
        element.COM_CRMRichiamare_il__c = Date.parse(element.COM_CRMRichiamare_il__c);
      if (element.COM_CRMRichiamare_ilASS__c)
        element.COM_CRMRichiamare_ilASS__c = Date.parse(element.COM_CRMRichiamare_ilASS__c);
      data[index] = element;
    });
    return data;
  },
  
  parseToDateArrayFromMillisecond: function (data) {
    data.forEach(function (element, index) {
      if (element.COM_CRMRichiamare_il__c)
        element.COM_CRMRichiamare_il__c = new Date(element.COM_CRMRichiamare_il__c).toLocaleDateString();
      if (element.COM_CRMRichiamare_ilASS__c)
        element.COM_CRMRichiamare_ilASS__c = new Date(element.COM_CRMRichiamare_ilASS__c).toLocaleDateString();
      data[index] = element;
    });
    return data;
  },
  
  doInit: function (component, event) {
    var currentDate= new Date();
    currentDate.setHours(18);
    try {
      component.set("v.currentDate", Date.parse(currentDate));
    } catch (e) {
      console.error(e);
    }
    try {
      var action = component.get("c.getAllInterviewsWithoutFilter");
      var dataList=[];
      action.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var d1 = new Date();
          var d2 = d1.setMinutes(d1.getMinutes() + 30);
          var currentMonth = d1.getMonth() + 1;
          //2019-05-02
          /*var curDate = component.get("v.currentDate");
          curDate = curDate.setMinutes(curDate.getMinutes() + 30);*/
          //curDate.setMinutes(curDate.getMinutes() + 30);
          var storeResponse = response.getReturnValue();
          storeResponse = this.filterList(component, storeResponse, null);
          component.set("v.datafilialList", storeResponse);
          var data = component.get("v.datafilialList");
          //console.log("geg",  );
          //var dataToShow = [];
          data = this.parseDateArray(data);
          var dataToShow = data.filter(row => {
            var dateLiquid = row.COM_D_liquid__c;
            var monthLiquid = dateLiquid.split('-')[1];;
            if ((currentMonth == monthLiquid &&
               row.COM_Stato_Avanzamento_IntervistaASS__c != "Non accetta" &&
               row.COM_Stato_Avanzamento_IntervistaASS__c != "Conclusa" &&
               row.COM_Stato_Avanzamento_IntervistaASS__c != "Irreperibile") &&
               (row.COM_CRMRichiamare_ilASS__c < d2 || row.COM_CRMRichiamare_ilASS__c == null )) {
              return row;
            }
          });
          console.log("datashow", dataToShow);

          component.set("v.dataInitial", data)
          /*data = data.filter(
            row =>
              row.COM_Stato_Avanzamento_IntervistaASS__c === "Nuovo" ||
              (row.COM_Stato_Avanzamento_IntervistaASS__c === "Richiamare" &&
                row.COM_CRMRichiamare_ilASS__c < d1)
          );*/
          component.set("v.objectList", []);
          component.set("v.objectList", dataToShow);
          this.initializePagination(component, dataToShow);
          // component.set("v.objectList", data);
        }
      });
      $A.enqueueAction(action);
        
        
      /**************************/
      var action1 = component.get("c.getInterviewTuttiContatti");
      var dataList1=[];
          action1.setCallback( this, function (response) 
          {
                  var state = response.getState();
                  if (state === "SUCCESS") 
                  {
                   var storeResponse = response.getReturnValue();
                  storeResponse = this.filterList(component, storeResponse, null);
                  component.set("v.dataTuttiContatti", storeResponse);
                  
                    }
                  });
               $A.enqueueAction(action1);
       
                
        
        
        
        
        
    } catch (e) { }
  },
  
  filterList: function (component, listObject, status) {
    //separate data archived and new or progressing
    var interviewNotArchived = [];
    //interviewNotArchived=recs;
    listObject.forEach(function (interviewAss) {
      if (interviewAss.COM_Status_ASS__c !== status) {
        interviewNotArchived.push(interviewAss);
      }
    });
    //  console.log('interview not Archived',JSON.stringify(interviewNotArchived));
    return interviewNotArchived;
  },
  
  PageDetails: function (component, recs) {
    var paginationList = [];
    for (var i = 0; i < recs.length; i++) {
      paginationList.push(recs[i]);
    }
    component.set("v.paginationList", paginationList);
  },
  
  initializePagination: function (component, recs) {
    var pageSize = component.get("v.pageSize");
    component.set("v.start", 0);
    component.set("v.end", pageSize - 1);
    var totalPage = Math.ceil(recs.length / pageSize);
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
  
  runSearch: function (component, event) {
    var action = component.get("c.execQueryFiltered");
    action.setParams({
      NameFiliale: component.get("v.dataName"),
      codiceFiliale: component.get("v.codiceFiliale"),
      numeroPratiche: component.get("v.numeroPratiche"),
      chiusoConforme: component.get("v.chiusoConforme"),
      chiusoNonConforme: component.get("v.chiusoNonConforme")
    });

    action.setCallback(this, function (actionResult) {
      if (action.getState() === "SUCCESS") {
        this.initializePagination(component, actionResult.getReturnValue()
        );
      } else if (action.getState() === "ERROR") {
        $A.log("Errors", action.getError());
      }
    });
    $A.enqueueAction(action);
  },

  showToast: function (message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      message: message,
      type: type
    });
    toastEvent.fire();
  },
  
  convertArrayOfObjectsToCSV: function (component, objectRecords) {
    try {
      this.parseToDateArrayFromMillisecond(objectRecords);
      //console.log("08_03_2019 objectRecords: ", JSON.stringify(objectRecords));
      // declare variables
      var csvStringResult,
        counter,
        keys,
        columnDivider,
        lineDivider,
        keysLabelName;
      // check if "objectRecords" parameter is null, then return from function
      if (objectRecords == null || !objectRecords.length) {
        return null;
      }
      // store ,[comma] in columnDivider variabel for sparate CSV values and
      // for start next line use '\n' [new line] in lineDivider varaible
      columnDivider = ",";
      lineDivider = "\n";
      // in the keys variable store fields API Names as a key
      // this labels use in CSV file header
      keys = [
        "COM_CRMNome_Cliente_Formula__c",
        "COM_N_Telefono_Cel__c",
        /*"COM_date_first_contacted__c",*/"COM_Data_Esito_ASS__c",
        "COM_MD_Filiale__r.Name",
        "COM_D_liquid__c",
        "LastModifiedDate",
        "COM_Ultimo_Esito_ASS__c",
        "COM_CRMRichiamare_ilASS__c",
        "COM_callback_notes__c",
        "COM_cin_z_calc__c"
      ];

      keysLabelName = [
        "CLIENTE",
        "TELEFONO",
        "DATA CONTATTO",
        "FILIALE",
        "DATA LIQUIDAZIONE",
        "DATA ULTIMA MODIFICA",
        "ULTIMO ESITO",
        "RICHIAMARE IL",
        "NOTE",
        "CIN Z"
      ];

      csvStringResult = "";
      csvStringResult += keysLabelName.join(columnDivider);
      csvStringResult += lineDivider;

      for (var i = 0; i < objectRecords.length; i++) {
        counter = 0;
        var dateMod = objectRecords[i]["LastModifiedDate"];
        //var dateRich = objectRecords[i]['COM_CRMRichiamare_il__c'];
        var dateLiquid = objectRecords[i]["COM_D_liquid__c"];
        var dateContatto = objectRecords[i]["COM_Data_Esito_ASS__c"];
        /*
                if (dateRich != null) {
                    dateRich = dateRich.split('T')[0];
                    dateRich = dateRich.split('-').join('/');
                } else if (dateRich == undefined) {
                    dateRich = ' ';
                }*/
        if (dateMod != null) {
          dateMod = dateMod.split("T")[0];
          dateMod = dateMod.split("-").join("/");
        } else if (dateMod == undefined) {
          dateMod = " ";
        }
        if (dateLiquid != null) {
          dateLiquid = dateLiquid.split("-").join("/");
        } else if (dateLiquid == undefined) {
          dateLiquid = " ";
        }
        if( dateContatto != null ) {
          dateContatto = dateContatto.split("-").join("/");
        }else if( dateContatto == undefined ){
          dateContatto = " ";  
        }
              
        
       // console.log("dateMod type(" + typeof dateMod + ")", dateMod);
        //console.log("dateRich(" + typeof dateRich + ")", dateRich);

        for (var sTempkey in keys) {
          var skey = keys[sTempkey];
          // add , [comma] after every String value,. [except first]
          if (counter > 0) {
            csvStringResult += columnDivider;
          }
          if (skey.includes(".")) {
            var sk = skey.split(".");
            var sk1 = sk[0];
            var sk2 = sk[1];
            //check if value is undefined set empty
            if (objectRecords[i][sk1] != undefined) {
              if (objectRecords[i][sk1][sk2] == undefined) {
                csvStringResult += "";
              } else {
                 
                csvStringResult += '"' + objectRecords[i][sk1][sk2] + '"';
              }
            } else {
              csvStringResult += "";
            }
          } else {
              
              
            if (skey === "LastModifiedDate")
              csvStringResult += '"' + dateMod + '"';
            /*
                        else if (skey === 'COM_CRMRichiamare_il__c')
                            csvStringResult += '"' + dateRich + '"';*/ else if (
              skey === "COM_D_liquid__c"
            )
              csvStringResult += '"' + dateLiquid + '"';
            else if( skey === "COM_Data_Esito_ASS__c")
               csvStringResult += '"' + dateContatto + '"';
            else if (objectRecords[i][skey] == undefined)
              csvStringResult += " ";
            else csvStringResult += '"' + objectRecords[i][skey] + '"';
            
          }

          counter++;
        } // inner for loop close
        csvStringResult += lineDivider;
      } // outer main for loop close
      // return the CSV formate String
    } catch (err) {
      console.log("-03_04_2019 err->" + err);
    }
    return csvStringResult;
  },
  
  isDatebetween: function (date, dateDA, dateA) {
    date = new Date(date);
    if (dateDA != "") {
      dateDA = new Date(dateDA);
    } else {
      this.showToast("Selezionare un intervallo valido", "Error");
      /*
      this.showToast(
        "Data liquidazione deve contenere un valore di ricerca.",
        "ERROR"
      );*/
      return true;
    }
    if (dateA != "") {
      dateA = new Date(dateA);
    } else dateA = new Date();
    if (dateA < dateDA) {
      this.showToast(
        "Selezionare un intervallo valido.",
        "ERROR"
      );
      return false;
    }
    return date >= dateDA && date <= dateA;
  },
  
  sortByCliente: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    //currentList      = component.get("v.paginationList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
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
    this.initializePagination(component, component.get("v.objectList"));
  },
  
  sortByFiliale: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    //currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
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
    this.initializePagination(component, component.get("v.objectList"));
  },
  
  sortByTelefono: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    //      currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
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
    this.initializePagination(component, component.get("v.objectList"));
  },
  
  sortByDataLiquidazione: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    //currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
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
    this.initializePagination(component, component.get("v.objectList"));
  },
  
  sortByDataContatto: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    //currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
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
    this.initializePagination(component, component.get("v.objectList"));
  },
  
  sortByDataUltimaModifica: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    //currentList = component.get("v.objectList");
    currentOrder = !currentOrder;

    currentList.sort(function (a, b) {
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
    this.initializePagination(component, component.get("v.objectList"));
  },

  sortCompare: function (component, a, b) {
    var currentOrder = component.get("v.isAsc");
    currentList = component.get("v.objectList");
    if (a.COM_Ultimo_Esito_ASS__c === null) {
      return 1;
    } else if (b.COM_Ultimo_Esito_ASS__c === null) {
      return -1;
    } else if (a.COM_Ultimo_Esito_ASS__c === b.COM_Ultimo_Esito_ASS__c) {
      return 0;
    } else if (currentOrder) {
      return a.COM_Ultimo_Esito_ASS__c < b.COM_Ultimo_Esito_ASS__c ? -1 : 1;
    } else if (!currentOrder) {
      return a.COM_Ultimo_Esito_ASS__c < b.COM_Ultimo_Esito_ASS__c ? 1 : -1;
    }
  },

  sortByUltimoEsito: function (component) {
    var currentOrder = component.get("v.isAsc");
    var currentList = component.get("v.objectList");
    currentOrder = !currentOrder;

    currentList.sort(function (a, b) {
      if (a.COM_Ultimo_Esito_ASS__c != null && b.COM_Ultimo_Esito_ASS__c) {
        console.log("object : " + a.COM_Ultimo_Esito_ASS__c);
        var t1 = a.COM_Ultimo_Esito_ASS__c == b.COM_Ultimo_Esito_ASS__c,
          t2 = a.COM_Ultimo_Esito_ASS__c < b.COM_Ultimo_Esito_ASS__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      else
        return -1;
    });

    /*currentList.sort(function (a, b) {
      if (a.COM_Ultimo_Esito_ASS__c === null) {
        return 1;
      } else if (b.COM_Ultimo_Esito_ASS__c === null) {
        return -1;
      } else if (a.COM_Ultimo_Esito_ASS__c === b.COM_Ultimo_Esito_ASS__c) {
        return 0;
      } else if (currentOrder) {
        return a.COM_Ultimo_Esito_ASS__c < b.COM_Ultimo_Esito_ASS__c ? -1 : 1;
      } else if (!currentOrder) {
        return a.COM_Ultimo_Esito_ASS__c < b.COM_Ultimo_Esito_ASS__c ? 1 : -1;
      }
    });*/
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, component.get("v.objectList"));
  },

  sortByRichiamareIl: function (component) {
    console.log("sortByRichiamareIl");
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
      if (a.COM_CRMRichiamare_ilASS__c != null && b.COM_CRMRichiamare_ilASS__c != null) {
        var t1 = a.COM_CRMRichiamare_ilASS__c == b.COM_CRMRichiamare_ilASS__c,
          t2 = a.COM_CRMRichiamare_ilASS__c < b.COM_CRMRichiamare_ilASS__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      else
        return -1;
    });

    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, component.get("v.objectList"));
  },
 
  sortByNote: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
      if (a.COM_callbackASS_notes__c != null && b.COM_callbackASS_notes__c != null) {
        var t1 = a.COM_callbackASS_notes__c == b.COM_callbackASS_notes__c,
          t2 = a.COM_callbackASS_notes__c < b.COM_callbackASS_notes__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      else
        return -1;
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, component.get("v.objectList"));
  },
  
  sortByCINZ: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    //currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
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
    this.initializePagination(component, component.get("v.objectList"));
  },

  setKeyFilter: function (component, key, filterValue) {
    //var data = component.get("v.datafilialList");
    var dataByFiliali = component.get("v.datafilialList");
    var initialData = component.get("v.dataInitial");

    var data = component.get("v.objectList");
    var dataTemp;
    //key = key.replace(/[^a-zA-Z0-9]/g, '');
    var regex;
    if ($A.util.isEmpty(key) || !key) {
      //dataTemp = data;
      if (dataByFiliali.length == 0) {
        dataTemp = initialData;
      } else {
        dataTemp = dataByFiliali;
      }
    } else {
      try {
        regex = new RegExp(key, "i");

        dataTemp = data.filter(function (row) {
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
            var chars = row.LastModifiedDate.split("T");
            if (chars[0] && key) return chars[0] === key;
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
      } catch (e) {
        console.error(e);
      }
    }
    this.initializePagination(component, dataTemp);
  },
    
  changeArrowDirection: function (component) {
    console.log("fleche");
    var currentDir = component.get("v.arrowDirection");
    if (currentDir == "arrowup") {
      console.log("arrowup-----");
      component.set("v.arrowDirection", "arrowdown");
    } else {
      console.log("arrowDown-----");
      component.set("v.arrowDirection", "arrowup");
      //ArrowCliente = "DESC";
    }
  }
    
});