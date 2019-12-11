({
  AdministrationClienteHelper: function(component, event, helper) {
    var month = document.getElementById("monthSelect");
   var keyMonth = month.options[month.selectedIndex].value;
    var year = document.getElementById("yearSelect");status
    var keyYear = year.options[year.selectedIndex].value;
    var total = document.getElementById("status");
    var keyTotal = total.options[total.selectedIndex].value;
    component.set("v.keyTotal", keyTotal);
    component.set("v.keyMonth", keyMonth);
    component.set("v.keyYear", keyYear);
    var compEventSource=component.getEvent("mostraConttati");
    compEventSource.setParams({mostraConttati: event.getSource().get("v.name")});
    compEventSource.fire();
    var cmpEvent = component.getEvent("heure");
    cmpEvent.setParams({ month: component.get("v.keyMonth") });
    cmpEvent.setParams({ year: component.get("v.keyYear") });
    cmpEvent.setParams({ total: component.get("v.keyTotal") });
    cmpEvent.fire();
    var eventPratiche = $A.get("e.c:eventFuturoClientePaginazione");
    eventPratiche.fire();
  },
  AdministrationAgenteHelper: function(component, event, helper) {

    var month = document.getElementById("monthSelect");
    var keyMonth = month.options[month.selectedIndex].value;
    var year = document.getElementById("yearSelect");
    var keyYear = year.options[year.selectedIndex].value;
    var total = document.getElementById("status");
    var keyTotal = total.options[total.selectedIndex].value;
    component.set("v.keyTotal", keyTotal);
    component.set("v.keyMonth", keyMonth);
    component.set("v.keyYear", keyYear);
    var cmpEvent = component.getEvent("heure");
    cmpEvent.setParams({ month: component.get("v.keyMonth") });
    cmpEvent.setParams({ year: component.get("v.keyYear") });
    cmpEvent.setParams({ total: component.get("v.keyTotal") });
    cmpEvent.fire();
    var eventPratiche = $A.get("e.c:eventFuturoAmministrazionneAgente");
    eventPratiche.fire();
  },

  GetYearsHelper: function(component, event, helper) {
    var years;
    var y;
    for (y = 2000; y <= 2500; y++) {
      years.add(y);
    }
    component.set("v.years", years);
    console.log("mes annees" + JSON.stringify(component.get("v.years")));
  }
});