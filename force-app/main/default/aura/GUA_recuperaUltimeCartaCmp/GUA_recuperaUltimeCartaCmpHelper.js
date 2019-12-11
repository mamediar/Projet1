({
  getAllPratiche: function(component, event) {
    var tipo = "CA";
    var caseData = component.get("v.case");

    var action = component.get("c.retrieveAllPraticheCarta");
    action.setParams({
      numPratica: caseData.numPratica,
      tipo: tipo,
      codiceCliente: caseData.codiceCliente
    });
    component.set("v.spinner", true);
    action.setCallback(this, function(response) {
      var state = response.getState();
      component.set("v.spinner", false);

      if (state === "SUCCESS") {
        var response = response.getReturnValue();

        if (response.error) {
          this.showToast("Error", response.message, "error");
        } else {
          try {
            var initCarta = JSON.parse(response.data).pratiche;
            var clienteList = JSON.parse(response.data).cliente;

            if (initCarta.length > 0 && clienteList.length > 0) {
              component.set("v.hasRow", true);
              var cartaList = [];

              initCarta.forEach(a => {
                clienteList.forEach(b => {
                  if (a.codCliente === b.codCliente) {
                    var cartaCliente = {};
                    cartaCliente.numPratica = a.numPratica;
                    cartaCliente.codCliente = a.codCliente;
                    cartaCliente.denominazione = b.denominazioneAzienda;
                    cartaCliente.statoPratica = a.statoPratica;
                    cartaCliente.status = "Approvate";
                    cartaList.push(cartaCliente);

                    cartaCliente = {};
                  }
                });
              });
              component.set("v.initData", cartaList);
              this.initializePagination(component,cartaList)
              cartaList = [];
            } else {
              component.set("v.hasRow", false);
              this.showToast("Error", "Nessun dato trovato!", "warning");
            }
          } catch (error) {
            console.log(error.getMessage());
          }
        }
      } else {
        this.showToast(
          "Errore",
          "Si è verificato un errore durante il recupero dei dati dal server!",
          "error"
        );
      }
    });
    $A.enqueueAction(action);
  },

  doFilter: function(component, event) {
    var initialData = component.get("v.initData");

    if (initialData.length > 0) {
      component.set("v.hasRow", true);
      this.filterData(component, initialData);
    } else {
      component.set("v.hasRow", false);
    }
  },

  filterData: function(component, datas) {
    var critera = component.get("v.filterValue");
    var filteredData = datas.filter(row => row.status === critera);
    if (!filteredData.length > 0) {
      this.showToast(
        "AVVERTIMENTO",
        "Nessun set di dati trovato per i criteri di filtro!",
        "warning"
      );
    }
    this.initializePagination(component,filteredData)

  },

  showToast: function(title, message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: title,
      message: message,
      type: type
    });
    toastEvent.fire();
  },

  initializePagination: function(component, datas) {
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

  PageDetails: function(component, recs) {
    var paginationList = [];
    for (var i = 0; i < recs.length; i++) {
      paginationList.push(recs[i]);
    }
    component.set("v.paginationList", paginationList);
  }
});