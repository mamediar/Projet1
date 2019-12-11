({
  /**
   * @description: Function to fetch data from server called in initial loading of page
   * @date::17/05/2019
   * @author:Mame Seynabou Diop
   * @return: none
   * @modification:
   */
  fetchCommodities: function(component, event, helper) {
    try {
      var curDate=Date.parse(new Date());
      component.set("v.currentDate", curDate);
    } catch (e) {
      console.error(e);
    }
    var initialList= this.parseDateArray(component.get("v.objectList"));
    initialList = initialList.filter(
      row => row.COM_Status_FUTURO__c !== "Archived" && row.COM_Current_Period_Futuro__c===true
    );
    component.set("v.loadFilterList",initialList);
    var arraysOfNames = [];
    initialList.forEach(function(element) {
      console.log(element);
      if (!arraysOfNames.includes(element.COM_AGENTE_FUTURO__r.Name)) {
        arraysOfNames.push(element.COM_AGENTE_FUTURO__r.Name);
      }
    });
    component.set("v.filterList", arraysOfNames);
    var praticheList = initialList;
    console.log("curdate"+curDate);
    console.log("mes données"+JSON.stringify(praticheList));
    if(component.get("v.pratiche")=="pratiche"){
    praticheList = praticheList.filter(
      row =>
        (row.Ultimo_Esito__c === "Richiamare" &&
        row.richiamare_il__c <= curDate )||  row.Ultimo_Esito__c === "Non risponde" ||(row.Ultimo_Esito__c!= "Conclusa" && row.Ultimo_Esito__c!= "Non risponde" && row.Ultimo_Esito__c!= "Richiamare" &&
            row.Ultimo_Esito__c!= "Non accetta" && row.Ultimo_Esito__c!= "Irreperibile" 
           )
    );
    component.set("v.resetList",praticheList);
    this.initializePagination(component, null, praticheList);
    
    }
    else if(component.get("v.mostraConttati")=="mostraChuisi"){
      var praticheList = this.parseDateArray(component.get("v.objectList"));
      component.set("v.fromAmministrazione",true);
      var mois = component.get("v.keyMonth");
      var annee = component.get("v.keyYear");
      praticheList = praticheList.filter(
        row =>row.COM_Current_Period_Futuro__c===true
      );
      var monthNames = new Array("Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno",
"Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre");

      praticheList.forEach(function (element) {
        var dateFiltre = new Date(element.CreatedDate);
        var year = dateFiltre.getFullYear();
        var month = monthNames[dateFiltre.getMonth()];
        if (month == mois && year == annee) {
          praticheList= praticheList.filter(
            row => row.Ultimo_Esito__c === "Conclusa"
          );
        } 
        else
        praticheList=[];
      });
      component.set("v.total",praticheList.length);
      component.set("v.listAdmin",praticheList);
      this.initializePagination(component, null, praticheList);
    }
    
  },
  /**
   * @description: method for set details of pagination commodity_Survey list
   * @date::20/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, dataCommoditySurvey
   * @return: none
   * @modification:
   */
  PageDetails: function(component, recs) {
    var paginationList = [];
    for (var i = 0; i < recs.length; i++) {
      paginationList.push(recs[i]);
    }
    component.set("v.praticheList", paginationList);
    //component.set("v.dataSurveyList",paginationList);
  },
  /**
   * @description: method for initialize pagination commodity_Survey list
   * @date::20/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, dataCommoditySurvey
   * @return: none
   * @modification:
   */
  initializePagination: function(component, event, recs) {
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

    component.set("v.praticheList",paginationList);
    component.set("v.dataSurveyList", recs);
    component.set("v.currentPage", 1);
    this.PageDetails(component, paginationList);
  },
  /**
   * @description: method for change direction of sort
   * @date::22/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, column
   * @return: none
   * @modification:
   */
  changeArrowDirection: function(component) {
    var currentDir = component.get("v.arrowDirection");
    if (currentDir == "arrowup") {
      console.log("arrowup-----");
      component.set("v.arrowDirection", "arrowdown");
    } else {
      component.set("v.arrowDirection", "arrowup");
    }
  },
  /**
   * @description: method for sort by column
   * @date::22/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, column
   * @return: none
   * @modification:
   */
  sortByColumn: function(component, column) {
    var currentOrder = component.get("v.isAsc");
    var currentList;
    if(component.get("v.mostraConttati")=="mostraChuisi")
    currentList = component.get("v.listAdmin");
    else
     currentList = component.get("v.dataSurveyList");

    if (column === "Cliente") {
      component.set("v.selectedTabsoft", "Cliente");
    }
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a != null && b != null) {
        var FirstCell = "";
        var SecondCell = "";
        if (column === "Cliente") {
          FirstCell = a.COM_NOME_CEDENTE__c;
          SecondCell = b.COM_NOME_CEDENTE__c;
        }
        var t1 = FirstCell == SecondCell,
          t2 = FirstCell < SecondCell;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });

    this.changeArrowDirection(component);
var listSort;
    component.set("v.isAsc", currentOrder);
    if(component.get("v.mostraConttati")=="mostraChuisi"){
    component.set("v.listAdmin",currentList);
listSort=component.get("v.listAdmin");
    }
    else{
   //component.set("v.resetList", currentList);
   listSort=currentList;
    }
    this.initializePagination(component, event,listSort);
  },
  /**
   * @description: method for sort by column telefono
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, column
   * @return: none
   * @modification:
   */
  sortByTelefono: function(component, column) {
    var currentOrder = component.get("v.isAsc");
    var currentList;
    if(component.get("v.mostraConttati")=="mostraChuisi")
    currentList = component.get("v.listAdmin");
    else
     currentList = component.get("v.dataSurveyList");

    if (column === "Telefono") {
      component.set("v.selectedTabsoft", "Telefono");
    }
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a != null && b != null) {
        var FirstCell = "";
        var SecondCell = "";
        if (column === "Telefono") {
          FirstCell = a.COM_CED_TELEFONO1__c;
          SecondCell = b.COM_CED_TELEFONO1__c;
        }
        var t1 = FirstCell == SecondCell,
          t2 = FirstCell < SecondCell;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });

    this.changeArrowDirection(component);
    var listSort;
    component.set("v.isAsc", currentOrder);
    if(component.get("v.mostraConttati")=="mostraChuisi"){
      component.set("v.listAdmin",currentList);
  listSort=component.get("v.listAdmin");
      }
      else{
    // component.set("v.resetList", currentList);
     listSort=currentList;
      }
      this.initializePagination(component, event,listSort);
    },
  /**
   * @description: method for sort by column telefono cellulare
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, column
   * @return: none
   * @modification:
   */
  sortByTelefonoCellulare: function(component, column) {
    var currentOrder = component.get("v.isAsc");
    var currentList;
    if(component.get("v.mostraConttati")=="mostraChuisi")
    currentList = component.get("v.listAdmin");
    else
     currentList = component.get("v.dataSurveyList");

    if (column === "TelefonoCellulare") {
      component.set("v.selectedTabsoft", "TelefonoCellulare");
    }
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a != null && b != null) {
        var FirstCell = "";
        var SecondCell = "";
        if (column === "TelefonoCellulare") {
          FirstCell = a.COM_CED_TELEFONO_CELL__c;
          SecondCell = b.COM_CED_TELEFONO_CELL__c;
        }
        var t1 = FirstCell == SecondCell,
          t2 = FirstCell < SecondCell;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });

    this.changeArrowDirection(component);
    var listSort;
    component.set("v.isAsc", currentOrder);
    if(component.get("v.mostraConttati")=="mostraChuisi"){
      component.set("v.listAdmin",currentList);
  listSort=component.get("v.listAdmin");
      }
      else{
     listSort=currentList;
      }
      this.initializePagination(component, event,listSort);
  },
  /**
   * @description: method for sort by column data contatto
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, column
   * @return: none
   * @modification:
   */
  sortByDataConttato: function(component, column) {
    var currentOrder = component.get("v.isAsc");
    var currentList;
    if(component.get("v.mostraConttati")=="mostraChuisi")
    currentList = component.get("v.listAdmin");
    else
     currentList = component.get("v.dataSurveyList");

    if (column === "DataConttato") {
      component.set("v.selectedTabsoft", "DataConttato");
    }
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a != null && b != null) {
        var FirstCell = "";
        var SecondCell = "";
        if (column === "DataConttato") {
          FirstCell = a.COM_DATA_CONTRATTO__c;
          SecondCell = b.COM_DATA_CONTRATTO__c;
        }
        var t1 = FirstCell == SecondCell,
          t2 = FirstCell < SecondCell;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });

    this.changeArrowDirection(component);
    var listSort;
    component.set("v.isAsc", currentOrder);
    if(component.get("v.mostraConttati")=="mostraChuisi"){
      component.set("v.listAdmin",currentList);
  listSort=component.get("v.listAdmin");
      }
      else{
     listSort=currentList;
      }
      this.initializePagination(component, event,listSort);
  },
  /**
   * @description: method for sort by column Agente
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, column
   * @return: none
   * @modification:
   */
  sortByAgente: function(component, column) {
    var currentOrder = component.get("v.isAsc");
    var currentList;
    if(component.get("v.mostraConttati")=="mostraChuisi")
    currentList = component.get("v.listAdmin");
    else
     currentList = component.get("v.dataSurveyList");

    if (column === "Agente") {
      component.set("v.selectedTabsoft", "Agente");
    }
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a != null && b != null) {
        var FirstCell = "";
        var SecondCell = "";
        if (column === "Agente") {
          FirstCell = a.COM_AGENTE_FUTURO__r.Name;
          SecondCell = b.COM_AGENTE_FUTURO__r.Name;
        }
        var t1 = FirstCell == SecondCell,
          t2 = FirstCell < SecondCell;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });

    this.changeArrowDirection(component);
    var listSort;
    component.set("v.isAsc", currentOrder);
    if(component.get("v.mostraConttati")=="mostraChuisi"){
      component.set("v.listAdmin",currentList);
  listSort=component.get("v.listAdmin");
      }
      else{
     listSort=currentList;
      }
      this.initializePagination(component, event,listSort);
  },
  
  /**
   * @description: method for sort by column Data Caricamento
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, column
   * @return: none
   * @modification:
   */
  sortByDataCaricamento: function(component, column) {
    var currentOrder = component.get("v.isAsc");
    var currentList;
    if(component.get("v.mostraConttati")=="mostraChuisi")
    currentList = component.get("v.listAdmin");
    else
     currentList = component.get("v.dataSurveyList");
     if (column === "DataCaricamento") {
      component.set("v.selectedTabsoft", "DataCaricamento");
    }
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.COM_DATA_INSERIMENTO__c!= null) {
        var t1 = a.COM_DATA_INSERIMENTO__c ==  b.COM_DATA_INSERIMENTO__c,
          t2 = a.COM_DATA_INSERIMENTO__c <  b.COM_DATA_INSERIMENTO__c;
         
       return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });

    this.changeArrowDirection(component);
    var listSort;
    component.set("v.isAsc", currentOrder);
    if(component.get("v.mostraConttati")=="mostraChuisi"){
      component.set("v.listAdmin",currentList);
  listSort=component.get("v.listAdmin");
      }
      else{

     listSort=currentList;
      }
      this.initializePagination(component, event,listSort);
  },
  /**
   * @description: method for sort by column Data modifica
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, column
   * @return: none
   * @modification:
   */
  sortDataUltimaModifica: function(component, column) {
    var currentOrder = component.get("v.isAsc");
    var currentList;
    if(component.get("v.mostraConttati")=="mostraChuisi")
    currentList = component.get("v.listAdmin");
    else
     currentList = component.get("v.dataSurveyList");
     if (column === "DataUltimaModifica") {
      component.set("v.selectedTabsoft", "DataUltimaModifica");
    }
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
          if (a.LastModifiedDate!= null) {
            var t1 = a.LastModifiedDate ==  b.LastModifiedDate,
              t2 = a.LastModifiedDate <  b.LastModifiedDate;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });

    this.changeArrowDirection(component);
    var listSort;
    component.set("v.isAsc", currentOrder);
    if(component.get("v.mostraConttati")=="mostraChuisi"){
      component.set("v.listAdmin",currentList);
  listSort=component.get("v.listAdmin");
      }
      else{
     listSort=currentList;
      }
      this.initializePagination(component, event,listSort);
  },
  /**
   * @description: method for sort by column ultimo esito
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, column
   * @return: none
   * @modification:
   */
  sortUltimoEsito: function(component, column) {
    var currentOrder = component.get("v.isAsc");
    var currentList;
    if(component.get("v.mostraConttati")=="mostraChuisi")
    currentList = component.get("v.listAdmin");
    else
     currentList = component.get("v.dataSurveyList");
     if (column === "UltimoEsito") {
      component.set("v.selectedTabsoft", "UltimoEsito");
    }
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
      if (a.Ultimo_Esito__c != null && b.Ultimo_Esito__c) {
        var t1 = a.Ultimo_Esito__c == b.Ultimo_Esito__c,
          t2 = a.Ultimo_Esito__c < b.Ultimo_Esito__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      else
        return -1;
    });

    this.changeArrowDirection(component);
    var listSort;
    component.set("v.isAsc", currentOrder);
    if(component.get("v.mostraConttati")=="mostraChuisi"){
      component.set("v.listAdmin",currentList);
  listSort=component.get("v.listAdmin");
      }
      else{
     listSort=currentList;
      }
      this.initializePagination(component, event,listSort);
  },
  /**
   * @description: method for sort by column Richiamare Il
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, column
   * @return: none
   * @modification:
   */
  sortRichiamareIl: function(component, column) {
    var currentOrder = component.get("v.isAsc");
    var currentList;
    if(component.get("v.mostraConttati")=="mostraChuisi")
    currentList = component.get("v.listAdmin");
    else
     currentList = component.get("v.dataSurveyList");
     if (column === "RichiamareIl") {
      component.set("v.selectedTabsoft", "RichiamareIl");
    }
    currentOrder = !currentOrder;
    currentList.sort(function (a, b) {
      if (a.richiamare_il__c != null && b.richiamare_il__c!= null) {
        var t1 = a.richiamare_il__c== b.richiamare_il__c,
          t2 = a.richiamare_il__c < b.richiamare_il__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      else
        return -1;
    });

    this.changeArrowDirection(component);
    var listSort;
    component.set("v.isAsc", currentOrder);
    if(component.get("v.mostraConttati")=="mostraChuisi"){
      component.set("v.listAdmin",currentList);
  listSort=component.get("v.listAdmin");
      }
      else{
     listSort=currentList;
      }
      this.initializePagination(component, event,listSort);
  },
  /**
   * @description: method for sort by column Note
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, column
   * @return: none
   * @modification:
   */
  sortNote: function(component, column) {
    var currentOrder = component.get("v.isAsc");
    var currentList;
    if(component.get("v.mostraConttati")=="mostraChuisi")
    currentList = component.get("v.listAdmin");
    else
     currentList = component.get("v.dataSurveyList");
     if (column === "Note") {
      component.set("v.selectedTabsoft", "Note");
    }
    currentOrder = !currentOrder;
    currentList.sort(function(a, b) {
      if (a.Note__c!= null) {
        var t1 = a.Note__c ==  b.Note__c,
          t2 = a.Note__c <  b.Note__c;
        return t1 ? 0 : (currentOrder ? -1 : 1) * (t2 ? 1 : -1);
      }
      return true;
    });

    this.changeArrowDirection(component);
    var listSort;
    component.set("v.isAsc", currentOrder);
    if(component.get("v.mostraConttati")=="mostraChuisi"){
      component.set("v.listAdmin",currentList);
  listSort=component.get("v.listAdmin");
      }
      else{
     listSort=currentList;
      }
      this.initializePagination(component, event,listSort);
  },
  /**
   * @description: method for set value to filter cliente, telepho y agente
   * @date::20/05/2019
   * @author:Mame Seynabou Diop
   * @modification: NONE
   */
  setValueFilterHelper: function(component, event, helper) {
    component.set("v.ValueFilter",true);
    var nomeCliente = component.find("nomeCliente").get("v.value");
    var telefono = component.find("telefono").get("v.value");
    var agente = component.find("agente").get("v.value");

    var data =component.get("v.loadFilterList") ;  
    var select = document.getElementById("status");
    var key = select.options[select.selectedIndex].value;
    var curDate = component.get("v.currentDate");
    var statusKey = "",
      statusKey1 = "",
      statusKey2 = "";
    try {
      switch (key) {

           case "Pratiche liquidate":
              component.set("v.Richiami", false);
              statusKey = "";
          data = data.filter(
            row =>
            (row.Ultimo_Esito__c === "Richiamare" &&
            row.richiamare_il__c <= curDate) ||  row.Ultimo_Esito__c === "Non risponde" ||(row.Ultimo_Esito__c!= "Conclusa" && row.Ultimo_Esito__c!= "Non risponde" && row.Ultimo_Esito__c!= "Richiamare" &&
              row.Ultimo_Esito__c!= "Non accetta" && row.Ultimo_Esito__c!= "Irreperibile" 
             )
          );
          
          break;
        case "Mai Contatti":
            component.set("v.Richiami", false);
            statusKey = "";
          data = data.filter(
            row =>
            row.Ultimo_Esito__c!= "Conclusa" && row.Ultimo_Esito__c!= "Non risponde" && row.Ultimo_Esito__c!= "Richiamare" &&
            row.Ultimo_Esito__c!= "Non accetta" && row.Ultimo_Esito__c!= "Irreperibile" 
           
               );
          break;
        case "Richiami":
            component.set("v.Richiami", true);
          statusKey = "Non Risponde";
          statusKey1 = "Richiamare";
          data = data.filter(
            row =>
              row.Ultimo_Esito__c === "Richiamare" ||
              row.Ultimo_Esito__c === "Non Risponde"
          );
          
        
          break;
        default:
          statusKey = "";
          statusKey1 = "";
          statusKey2 = "";
          break;
      }
    } catch (e) {}
    if (nomeCliente) {
      data = data.filter(row =>
        row.COM_NOME_CEDENTE__c.toLowerCase().includes(
          nomeCliente.toLowerCase()
) );
      this.initializePagination(component, null, data);
    }
    if (telefono) {
      var praticheList=[];
      data.forEach(function(element) {
        if (element!=undefined) {
          if(element.COM_CED_TELEFONO_CELL__c!=null){
          praticheList.push(element);
          }

        }
       } );
       data=praticheList;
    data = data.filter(row =>
      row.COM_CED_TELEFONO_CELL__c.toLowerCase().includes(
        telefono.toLowerCase()
      )
    );

    this.initializePagination(component, null, data);
  }
    if (agente) {
      data = data.filter(row =>
        row.COM_AGENTE_FUTURO__r.Name.toLowerCase().includes(
          agente.toLowerCase()
        )
      );
      this.initializePagination(component, null, data);
    }
    if (nomeCliente != "" || nomeCliente != null) {
      component.set("v.nomeCliente", nomeCliente);
    } else if (telefono != "" || telefono != null) {
      component.set("v.telefono", telefono);
    } else if (agente != "" || agente != null) {
      component.set("v.agente", agente);
    } else {
      this.initializePagination(
        component,
        null,
        data
      );
    }
   if (nomeCliente == " " && telefono == " " && agente == " ") {
      this.initializePagination(
        component,
        null,
       data
      );
    }

  },
  /**
   * @description: method for reset filter
   * @date::20/05/2019
   * @author:Mame Seynabou Diop
   * @modification: NONE
   */

  resetFilterHelper: function(component, event, helper) {
    component.set("v.ValueFilter",false);
    component.find("nomeCliente").set("v.value", " ");
    component.find("telefono").set("v.value", "");
    component.find("agente").set("v.value", "");
    var data =component.get("v.loadFilterList") ;  
    var select = document.getElementById("status");
    var key = select.options[select.selectedIndex].value;
    var curDate = component.get("v.currentDate");
    var statusKey = "",
      statusKey1 = "",
      statusKey2 = "";
    try {
      switch (key) {

           case "Pratiche liquidate":
              component.set("v.Richiami", false);
              statusKey = "";
          data = data.filter(
            row =>
            (row.Ultimo_Esito__c === "Richiamare" &&
            row.richiamare_il__c <= curDate) ||  row.Ultimo_Esito__c === "Non risponde" ||(row.Ultimo_Esito__c!= "Conclusa" && row.Ultimo_Esito__c!= "Non risponde" && row.Ultimo_Esito__c!= "Richiamare" &&
              row.Ultimo_Esito__c!= "Non accetta" && row.Ultimo_Esito__c!= "Irreperibile" 
             )
          );
          
          break;
        case "Mai Contatti":
            component.set("v.Richiami", false);
            statusKey = "";
          data = data.filter(
            row =>
            row.Ultimo_Esito__c!= "Conclusa" && row.Ultimo_Esito__c!= "Non risponde" && row.Ultimo_Esito__c!= "Richiamare" &&
            row.Ultimo_Esito__c!= "Non accetta" && row.Ultimo_Esito__c!= "Irreperibile" 
           
               );
          break;
        case "Richiami":
            component.set("v.Richiami", true);
          statusKey = "Non Risponde";
          statusKey1 = "Richiamare";
          data = data.filter(
            row =>
              row.Ultimo_Esito__c === "Richiamare" ||
              row.Ultimo_Esito__c === "Non Risponde"
          );

          break;
        default:
          statusKey = "";
          statusKey1 = "";
          statusKey2 = "";
          break;
      }
    } catch (e) {}
    
    this.initializePagination(
      component,
      null,
 data
    );
  },
  /**
   * @description: method to filter Pratiche liquidat, Richiami y mai conttati
   * @date::21/05/2019
   * @author:Mame Seynabou Diop
   * @modification: NONE
   */

  filterCommoditySurveyHelper: function(component, event, helper) {
    var data =component.get("v.loadFilterList") ;  
    var nomeCliente = component.find("nomeCliente").get("v.value");
    var telefono = component.find("telefono").get("v.value");
    var agente = component.find("agente").get("v.value");
    if(component.get("v.ValueFilter")==true){
      if (nomeCliente) {
        data = data.filter(row =>
          row.COM_NOME_CEDENTE__c.toLowerCase().includes(
            nomeCliente.toLowerCase()
  ) );
      }
      if (telefono) {
        var praticheList=[];
        data.forEach(function(element) {
          if (element!=undefined) {
            if(element.COM_CED_TELEFONO_CELL__c!=null){
            praticheList.push(element);
            }
  
          }
         } );
         data=praticheList;
      data = data.filter(row =>
        row.COM_CED_TELEFONO_CELL__c.toLowerCase().includes(
          telefono.toLowerCase()
        )
      );
  
    }
      if (agente) {
        data = data.filter(row =>
          row.COM_AGENTE_FUTURO__r.Name.toLowerCase().includes(
            agente.toLowerCase()
          )
        );
      }
      if (nomeCliente != "" || nomeCliente != null) {
        component.set("v.nomeCliente", nomeCliente);
      } else if (telefono != "" || telefono != null) {
        component.set("v.telefono", telefono);
      } else if (agente != "" || agente != null) {
        component.set("v.agente", agente);
      } else {
        
          data=data;
        
      }
     if (nomeCliente == " " && telefono == " " && agente == " ") {
      data=data;
      }
  
    }
   
    var select = document.getElementById("status");
    var key = select.options[select.selectedIndex].value;
    var curDate = component.get("v.currentDate");
    var statusKey = "",
      statusKey1 = "",
      statusKey2 = "";
    try {
      switch (key) {

           case "Pratiche liquidate":
              component.set("v.Richiami", false);
              statusKey = "";
          data = data.filter(
            row =>
            (row.Ultimo_Esito__c === "Richiamare" &&
            row.richiamare_il__c <= curDate) ||  row.Ultimo_Esito__c === "Non risponde" ||(row.Ultimo_Esito__c!= "Conclusa" && row.Ultimo_Esito__c!= "Non risponde" && row.Ultimo_Esito__c!= "Richiamare" &&
              row.Ultimo_Esito__c!= "Non accetta" && row.Ultimo_Esito__c!= "Irreperibile" 
             )
          );
      
          break;
        case "Mai Contatti":
            component.set("v.Richiami", false);
            statusKey = "";
          data = data.filter(
            row =>
            row.Ultimo_Esito__c!= "Conclusa" && row.Ultimo_Esito__c!= "Non risponde" && row.Ultimo_Esito__c!= "Richiamare" &&
            row.Ultimo_Esito__c!= "Non accetta" && row.Ultimo_Esito__c!= "Irreperibile" 
           
               );
          break;
        case "Richiami":
            component.set("v.Richiami", true);
          statusKey = "Non Risponde";
          statusKey1 = "Richiamare";
          data = data.filter(
            row =>
              row.Ultimo_Esito__c === "Richiamare" ||
              row.Ultimo_Esito__c === "Non Risponde"
          );
          
        
          break;
        default:
          statusKey = "";
          statusKey1 = "";
          statusKey2 = "";
          break;
      }
    } catch (e) {}
    
  //  component.set("v.resetList", []);
   // component.set("v.resetList", data);
    this.initializePagination(component, null, data);
    data = [];
  },
  

  /**
   * @description: component called to get customer's details
   * @date::20/05/2019
   * @author:Mady COLY
   * @modification: NONE
   */
  navigateToCommunitySurveyDetailsHelper: function(component, event, helper) {
    var InterviewPosition = event.target.getAttribute("data-index");
    var InterviewCurrentObj = component.get("v.praticheList")[
      InterviewPosition
    ];
    var status = InterviewCurrentObj.COM_Status_FUTURO__c;
    var target = InterviewCurrentObj.COM_AGENTE_FUTURO__r.Com_Numero_Contatti__c;
    var IntervisteUtili = InterviewCurrentObj.Interviste_Utili__c;
    if(component.get("v.pratiche")=="pratiche"){
   if (status === "New") {
      if (IntervisteUtili === target || IntervisteUtili > target) {
        var toastParams = {
          title: "Impossible",
          message:
            "Non è possibile procedere, target mensile già raggiunto per questo Agente", 
          type: "error"
        };
        toastParams.message;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
       var object= {sobjectype:"Com_Commodity_Survey__c",Id:" ",COM_Status_FUTURO__c:" "};
       object.Id=InterviewCurrentObj.Id;
       object.COM_Status_FUTURO__c="Archived";
        console.log("avant update",JSON.stringify(object));
        var action3 = component.get("c.updateSobject");
        action3.setParam("mySobject", object);
        action3.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
              console.log("update",JSON.stringify(object));
            }
        });
        $A.enqueueAction(action3);
      } else {
        var evt = $A.get("e.c:eventNavigationToCommunityServey");
        evt.setParams({
          Id: InterviewCurrentObj.Id,
          fromAmministrazione : component.get("v.fromAmministrazione")
        });
        evt.fire();
      }
    } else {
      var toastParams = {
        title: "Impossible",
        message:
          "Non è possibile procedere, intervista in corso da altro operatore", // Default error message
        type: "error"
      };
      toastParams.message;
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams(toastParams);
      toastEvent.fire();
    }
  }
  else if(component.get("v.mostraConttati")=="mostraChuisi"){
    var evt = $A.get("e.c:eventNavigationToCommunityServey");
        evt.setParams({
          Id: InterviewCurrentObj.Id,
          fromAmministrazione : component.get("v.fromAmministrazione")
        });
        evt.fire();
  }
  },
  
  /**
   * @description: method to parse date
   * @date::11/06/2019
   * @author:Mame Seynabou Diop
   * @modification: NONE
   */
  parseDateArray: function(data) {
    data.forEach(function(element, index) {
      element.richiamare_il__c = Date.parse(
        element.richiamare_il__c
      );
      data[index] = element;
    });

    return data;
  },

 
});