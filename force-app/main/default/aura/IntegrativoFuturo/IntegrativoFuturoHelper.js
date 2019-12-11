({

    
    
  doInit: function (component,event,helper) {
    var currentDate= new Date();
    var curDate=Date.parse(currentDate);
    component.set("v.curDate",curDate);
    var dateColor=Date.parse(currentDate) + 1800000;
    component.set("v.dateColor",dateColor);

    
    try {
      component.set("v.currentDate", Date.parse(currentDate));
    } catch (e) {
      console.error(e);
    }
    component.set("v.curDate",curDate);
    var dataIntervistaList = component.get("v.dataIntervistaList");
    component.set("v.paginationList", dataIntervistaList);
    component.set("v.objectList", dataIntervistaList);
    dataIntervistaList = dataIntervistaList.filter(
      row =>
        ((row.Stato__c === "Richiamare" &&
          row.COM_Richiamare_il__c < dateColor) ||
          (row.Stato__c === "Non risponde" &&
            row.COM_Richiamare_il__c < dateColor) ||
          (row.Stato__c === "Non accetta" &&
            row.COM_Richiamare_il__c < dateColor) ||
          row.Stato__c === "vuoto") &&
        row.Status__c != "Archived"
    );
    this.initializePagination(component, dataIntervistaList);
  },
  parseDateArray: function (data) {
    data.forEach(function (element, index) {
      if (element.COM_Richiamare_il__c)
        element.COM_Richiamare_il__c = Date.parse(element.COM_Richiamare_il__c);
      data[index] = element;
    });
    return data;
  },
  initializePagination: function (component, datas) {
    var pageSize = component.get("v.pageSize");
    component.set("v.start", 0);
    component.set("v.end", pageSize - 1);
    var totalPage = Math.ceil(datas.length / pageSize);
    component.set("v.totalPage", totalPage);
    var pages = [];
    for (var i = 1; i <= totalPage; i++) {
      pages.push(i);
    }
    component.set("v.pages", pages);
    var paginationList = [];
    for (var i = 0; i < pageSize; i++) {
      if (datas.length > i) paginationList.push(datas[i]);
    }
    component.set("v.totalRecord", datas.length);
    component.set("v.objectList", datas);
    component.set("v.paginationList", paginationList);
    component.set("v.currentPage", 1);
    this.PageDetails(component, paginationList);
  },
 
  parseToDateArrayFromMillisecond: function (data) {
    data.forEach(function (element, index) {
      if (element.Data_Liquidazione__c){
        element.Data_Liquidazione__c = new Date(element.Data_Liquidazione__c).toLocaleDateString();
      }
      if (element.COM_Richiamare_il__c){
        element.COM_Richiamare_il__c = new Date(element.COM_Richiamare_il__c).toLocaleString();
        
      }
        
     
      data[index] = element;
    });
    return data;
  },
  getIntervisteDelmeseByProduct: function(component) {
    var action = component.get("c.countInterviewProduct");
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var datas = response.getReturnValue();
        component.set("v.dashbord", datas);
        var productsLimites = component.get("v.productsLimites");
        productsLimites["PA"] = productsLimites["PA"] < datas.PAConclusa;
        productsLimites["PP Altri"] =
          productsLimites["PP Altri"] < datas.PPAltriConclusa;
        productsLimites["PP Borg"] =
          productsLimites["PP Borg"] < datas.PPBorgConclusa;
          //productsLimites["PP Borg"] = true;
        var storeResponse = component.get("v.objectList");
        storeResponse = storeResponse.filter(function(element) {
          return !productsLimites[element.Plc_Tipo_Prodotto__c];
        });
        component.set("v.dataIntervistaList", storeResponse);
        
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
        component.set("v.dataInitial", storeResponse);
        this.initializePagination(component,storeResponse);
      } else {
      }
    });
    $A.enqueueAction(action);
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
    return interviewNotArchived;
  },
  PageDetails: function (component, recs) {
    var paginationList = [];
    for (var i = 0; i < recs.length; i++) {
      paginationList.push(recs[i]);
    }
    component.set("v.paginationList", paginationList);
  },
  sortByCliente: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
      if (a.Ac_Rag_Sociale_1__c != null && b.Ac_Rag_Sociale_1__c != null) {
        var t1 = a.Ac_Rag_Sociale_1__c == b.Ac_Rag_Sociale_1__c,
          t2 = a.Ac_Rag_Sociale_1__c < b.Ac_Rag_Sociale_1__c;
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
      if (a.Ac_Telefono_Cel__c != null && b.Ac_Telefono_Cel__c!= null) {
        var t1 = a.Ac_Telefono_Cel__c == b.Ac_Telefono_Cel__c,
          t2 = a.Ac_Telefono_Cel__c < b.Ac_Telefono_Cel__c;
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
      if (a.COM_date_first_contacted__c != null && b.COM_date_first_contacted__c!= null) {
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
  sortByIntermediario: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    //currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
      if (a.Ragione_Sociale_Intermediario__c != null && b.Ragione_Sociale_Intermediario__c!= null) {
        var t1 = a.Ragione_Sociale_Intermediario__c == b.Ragione_Sociale_Intermediario__c,
          t2 = a.Ragione_Sociale_Intermediario__c < b.Ragione_Sociale_Intermediario__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, component.get("v.objectList"));
  },
  sortByUtente: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    //      currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
      if (a.Owner.Name != null && b.Owner.Name!= null) {
        var t1 = a.Owner.Name == b.Owner.Name,
          t2 = a.Owner.Name < b.Owner.Name;
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
      if (a.Data_Liquidazione__c != null && b.Data_Liquidazione__c!= null) {
        var t1 = a.Data_Liquidazione__c == b.Data_Liquidazione__c,
          t2 = a.Data_Liquidazione__c < b.Data_Liquidazione__c;
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
      if (a.LastModifiedDate != null && b.LastModifiedDate != null) {
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
  sortByProdotto: function (component) {
    var currentOrder = component.get("v.isAsc"),
      currentList = component.get("v.objectList");
    //currentList = component.get("v.objectList");
    currentOrder = !currentOrder;

    currentList.sort(function (a, b) {
      if (a.Plc_Tipo_Prodotto__c != null) {
        var t1 = a.Plc_Tipo_Prodotto__c == b.Plc_Tipo_Prodotto__c,
          t2 = a.Plc_Tipo_Prodotto__c < b.Plc_Tipo_Prodotto__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });
    this.changeArrowDirection(component);
    component.set("v.isAsc", currentOrder);
    component.set("v.objectList", currentList);
    this.initializePagination(component, component.get("v.objectList"));
  },
  sortByUltimoEsito: function (component) {
    var currentOrder = component.get("v.isAsc");
    var currentList = component.get("v.objectList");
    currentOrder = !currentOrder;

    currentList.sort(function (a, b) {
      if (a.Stato__c != null && b.Stato__c) {
        var t1 = a.Stato__c == b.Stato__c,
          t2 = a.Stato__c < b.Stato__c;
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
  sortByRichiamareIl: function (component) {
    var currentOrder = component.get("v.isAsc"),
    currentList = component.get("v.objectList");
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
      if (a.COM_Richiamare_il__c != null && b.COM_Richiamare_il__c != null) {
        var t1 = a.COM_Richiamare_il__c == b.COM_Richiamare_il__c,
          t2 = a.COM_Richiamare_il__c < b.COM_Richiamare_il__c;
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
      if (a.Notes__c != null && b.Notes__c != null) {
        var t1 = a.Notes__c == b.Notes__c,
          t2 = a.Notes__c < b.Notes__c;
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
  changeArrowDirection: function (component) {
    var currentDir = component.get("v.arrowDirection");
    if (currentDir == "arrowup") {
      component.set("v.arrowDirection", "arrowdown");
    } else {
      component.set("v.arrowDirection", "arrowup");
      //ArrowCliente = "DESC";
    }
  },
  convertArrayOfObjectsToCSV: function (component, objectRecords) {

    try {
      objectRecords = this.parseToDateArrayFromMillisecond(objectRecords);
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
        "Ac_Rag_Sociale_1__c",
        "Ac_Telefono__c",
        "LastModifiedDate",
        "Ragione_Sociale_Intermediario__c",
        "Owner.Name",
        "Data_Liquidazione__c",
        "LastModifiedDate",
        "Stato__c",
        "COM_Richiamare_il__c",
        "Note__c",
      ];

      keysLabelName = [
        "CLIENTE",
        "TELEFONO",
        "DATA CONTATTO",
        "INTERMEDIARIO",
        "UTENTE",
        "DATA LIQUIDAZIONE",
        "DATA ULTIMA MODIFICA",
        "ULTIMO ESITO",
        "RICHIAMARE IL",
        "NOTE"
      ];

      csvStringResult = "";
      csvStringResult += keysLabelName.join(columnDivider);
      csvStringResult += lineDivider;

      for (var i = 0; i < objectRecords.length; i++) {
        counter = 0;
        var dateMod = objectRecords[i]["LastModifiedDate"];
        
        var dateLiquid = objectRecords[i]["Data_Liquidazione__c"];
        
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
                //console.log(
                //  "11_03_2019 record[" + i + "]: " + sk1 + "." + sk2,
                //  objectRecords[i][sk1][sk2]
               // );
                csvStringResult += '"' + objectRecords[i][sk1][sk2] + '"';
               //console.log("Indirected", objectRecords[i][sk1][sk2]);
              }
            } else {
              csvStringResult += "";
            }
          } else {
            if (skey === "LastModifiedDate")
              csvStringResult += '"' + dateMod + '"';
             else if (
              skey === "Data_Liquidazione__c"
            )
              csvStringResult += '"' + dateLiquid + '"';
            else if (objectRecords[i][skey] == undefined)
              csvStringResult += " ";
            else csvStringResult += '"' + objectRecords[i][skey] + '"';

            ////console.log(
             // "11_03_2019 record[" + i + "]: " + skey,
             // objectRecords[i][skey]
           // );
          }

          counter++;
        } // inner for loop close
        csvStringResult += lineDivider;
      } // outer main for loop close
      // return the CSV formate String
    } catch (err) {
      //console.log("-03_04_2019 err->" + err);
    }
    return csvStringResult;
  },
  showToast: function (message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      message: message,
      type: type
    });
    toastEvent.fire();
  },
  isDatebetween: function (date, dateDA, dateA) {
    date = new Date(date);
    if (dateDA != "") {
      dateDA = new Date(dateDA);
    } else {
      this.showToast("Selezionare un intervallo valido", "Error");
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
/**
 * @description: method for set value to filter cliente, telepho y agente
 * @date::12/06/2019
 * @author:Aminata GUEYE
 * @modification: NONE
 */
setValueFilterHelper: function(component, event, helper) {
  var data = component.get("v.dataIntervistaList");  
  var select = document.getElementById("prodottoFilter");
  var key = select.options[select.selectedIndex].value;
    switch (key) {
      case "Tutti":
    data = data;
    this.initializePagination(component, data);
    break;
      case "PA":
     data = data.filter(
       row =>
         row.Plc_Tipo_Prodotto__c === "PA"
     );
     this.initializePagination(component, data);
     break;
     case "PF":
      data = data.filter(
        row =>
          row.Plc_Tipo_Prodotto__c === "PF"
      );
      this.initializePagination(component, data);
      break;
        case "PP Altri":
       data = data.filter(
         row =>
           row.Plc_Tipo_Prodotto__c === "PP Altri"
       );
       this.initializePagination(component, data);
       break;
       case "PP Borg":
       data = data.filter(
         row =>
           row.Plc_Tipo_Prodotto__c === "PP Borg"
       );
       this.initializePagination(component, data);
       break;
} 
}
});