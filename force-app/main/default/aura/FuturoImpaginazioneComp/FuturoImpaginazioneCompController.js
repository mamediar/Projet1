({
  /**
   * @description: method init on load page and call helper.doInit
   * @date::16/05/2019
   * @author:Khadim Rassoul Ndeye
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  init: function(component, event, helper) 
  {
    var isFiltered = component.get('v.isFiltered');
    if(isFiltered){
      var objectList = component.get('v.objectList');
      helper.initializePagination(component, null, objectList);
    }else{
      helper.doInit(component, event);
    }
    
  },
  showSpinner: function(component) 
  {
    component.set("v.activeSpinner", true);
  },
  hideSpinner: function(component) 
  {
    component.set("v.activeSpinner", false);
  },
  getPratiche: function(component, event, helper) 
  {
    var compEventSource=component.getEvent("praticheCliente");
    compEventSource.setParams({praticheCliente: event.getSource().get("v.name")});
    compEventSource.fire();
    var eventPratiche = $A.get("e.c:eventFuturoClientePaginazione");
        eventPratiche.setParams({
          "loadData": true
      });
    eventPratiche.fire();
  },
  sortCodiceAgente: function( component,event,helper)
  {
      helper.sortCodiceAgenteHelper(component, event,helper);
  },
  sortAgente: function( component,event,helper )
  {
      helper.sortAgenteHelper(component, event,helper);
  },
  sortTarget: function( component,event,helper)
  {
      helper.sortTargetHelper(component, event,helper);
  },
  sortNumeroPratiche: function( component,event,helper)
  {
      helper.sortNumeroPraticheHelper(component, event,helper);   
        
  },
  sortChiusoConforme: function( component,event,helper)
  {
      helper.sortChiusoConformeHelper(component, event,helper);
  },
  sortChiusoNonConforme: function( component,event,helper)
  {
      helper.sortChiusoNonConformeHelper(component, event,helper);  
  },
  /**
   * @description: method for filter Agente and totals
   * @date:: 21/05/2019
   * @author: Aminata GUEYE
   * @params: component, event, helper
   * @return: none
   * @modification:
   */

  filterAgente: function(component, event, helper) {
      var select = document.getElementById("status");
      var key = select.options[select.selectedIndex].value;
      helper.visualizzaPer(component, key);
      
    },
    getclienteByAgente: function(component, event , helper){
      helper.navigateToFuturoImpaginazioneComp(component,event);
    },
    adminAgente: function(component, event , helper){
      var dataF= event.getParam('dataF');
    console.log('dataF recu de event', dataF);
    },
});