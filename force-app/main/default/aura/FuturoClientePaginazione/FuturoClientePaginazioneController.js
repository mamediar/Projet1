({
      /**
   * @description: method redirect to Futuro Page
   * @date::16/05/2019
   * @author:Mady COLY
   * @modification: NONE
   */
	redirect: function(component, event, helper) {
    if(component.get('v.pratiche')){
    var eventGoFuturo = $A.get("e.c:eventNavigateToFuturo");
    eventGoFuturo.setParams({
      "Id": component.get('v.recordId')
  });
}else 
var eventGoFuturo = $A.get("e.c:eventNavigatetoAmministrazione");
    eventGoFuturo.fire();
  },

  /**
   * @description: Function called on initial page loading to get customer list from server
   * @date::17/05/2019
   * @author:Mame Seynabou Diop
   * @modification: NONE
   */
        getCedenteCommodities : function(component, event, helper) {
          component.set('v.loaded', !component.get('v.loaded'));
                helper.fetchCommodities(component, event, helper);
        },

              /**
   * @description: component called to get customer's details
   * @date::20/05/2019
   * @author:Mady COLY
   * @modification: NONE
   */
  navigateToCommunitySurveyDetails: function(component, event, helper){
   helper.navigateToCommunitySurveyDetailsHelper(component,event,helper);  
  },
              /**
   * @description: method for set value to filter cliente, telepho y agente
   * @date::20/05/2019
   * @author:Mame Seynabou Diop
   * @modification: NONE
   */
        setValueFilter: function(component, event, helper) {
          helper.setValueFilterHelper(component,event,helper);
           },
            /**
   * @description: method for reset filter
   * @date::20/05/2019
   * @author:Mame Seynabou Diop
   * @modification: NONE
   */

            resetFilter: function(component,event,helper){
            helper.resetFilterHelper(component,event,helper);
           },                                     

           /**
   * @description: method to filter Pratiche liquidat, Richiami y mai conttati
   * @date::21/05/2019
   * @author:Mame Seynabou Diop
   * @modification: NONE
   */

           filterCommoditySurvey: function(component, event, helper) {
            helper.filterCommoditySurveyHelper(component, event, helper);
           },

           /**
   * @description: method for sort field Cliente
   * @date::22/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  sortClienteFiliali: function(component, event, helper) {
    helper.sortByColumn(component, "Cliente");
  },
      /**
   * @description: method for sort field telefono
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  sortTelefono: function(component, event, helper) {
    helper.sortByTelefono(component, "Telefono");
  },
      /**
   * @description: method for sort field telefono cellulaire
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  sortTelefonoCellulare: function(component, event, helper) {
    helper.sortByTelefonoCellulare(component, "TelefonoCellulare");
  },
    /**
   * @description: method for sort field data conttato
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  sortDataConttato: function(component, event, helper) {
    helper.sortByDataConttato(component, "DataConttato");
  },
    /**
   * @description: method for sort field Agente
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  sortAgente: function(component, event, helper) {
    helper.sortByAgente(component, "Agente");
  },
    /**
   * @description: method for sort field utente
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  sortUtente: function(component, event, helper) {
    helper.sortByUtente(component, "Utente");
  },
    /**
   * @description: method for sort field data caricamento
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  sortDataCaricamento: function(component, event, helper) {
    helper.sortByDataCaricamento(component, "DataCaricamento");
  },

    /**
   * @description: method for sort field data ultima modifica
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  sortDataUltimaModifica: function(component, event, helper) {
    helper.sortDataUltimaModifica(component, "DataUltimaModifica");
  }
  ,
    /**
   * @description: method for sort field ultimo esito
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  sortUltimoEsito: function(component, event, helper) {
    helper.sortUltimoEsito(component, "UltimoEsito");
  }
  ,
    /**
   * @description: method for sort field richiamare il
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  sortRichiamareIl: function(component, event, helper) {
    helper.sortRichiamareIl(component, "RichiamareIl");
  }
  ,
    /**
   * @description: method for sort field Note
   * @date::23/05/2019
   * @author:Mame Seynabou Diop
   * @params: component, event, helper
   * @return: none
   * @modification:
   */
  sortNote: function(component, event, helper) {
 
    helper.sortNote(component, "Note");
  },
  // this function automatic call by aura:waiting event  
  showSpinner: function(component, event, helper) {
    // make Spinner attribute true for display loading spinner 
     component.set("v.Spinner", true); 
},
 
// this function automatic call by aura:doneWaiting event 
 hideSpinner : function(component,event,helper){
  // make Spinner attribute to false for hide loading spinner    
    component.set("v.Spinner", false);
 },
 

})