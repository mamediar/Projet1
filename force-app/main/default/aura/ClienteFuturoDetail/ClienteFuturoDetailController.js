({
   /**
   * @description: find a object Community Servey By Id
   * @dateCreate:22/05/2019
   * @author:Mady COLY
   * @dateLastModification: none
   */
	doInit : function(component, event, helper) {
      helper.getClienteDetailFuturo(component);
   },
   redirectToFuturoImpaginazioneComp: function (component, event, helper) {
      var eventRefreshIntervista = $A.get("e.c:eventFuturoClientePaginazione");
      eventRefreshIntervista.setParams({
          "loadData": true
      });
      eventRefreshIntervista.fire();
      },
      handleNext : function(component,event,helper){
         helper.handleNext(component);
     },
     getRespondeQuezione1 : function(component,event,helper){
       helper.getRespondeQuezione1(component,event);
     },
     rispondeIntervista1 : function(component,event,helper){
       helper.getRispondeIntervista1(component,event);
     },
     rispondeIntervista2 : function(component,event,helper){
       helper.getRispondeIntervista2(component,event);
     },
     rispondeIntervista3 : function(component,event,helper){
       helper.getRispondeIntervista3(component,event);
     },
     rispondeIntervista4 : function(component,event,helper){
       helper.getRispondeIntervista4(component,event);
     },
     rispondeIntervista5 : function(component,event,helper){
       helper.getRispondeIntervista5(component,event);
     },
     rispondeIntervista6 : function(component,event,helper){
       helper.getRispondeIntervista6(component,event);
     },
     rispondeIntervista6bis : function(component,event,helper){
       helper.getRispondeIntervista6bis(component,event);
     },
     rispondeIntervista7 : function(component,event,helper){
       helper.getRispondeIntervista7(component,event);
     },
     rispondeIntervista8 : function(component,event,helper){
       helper.getRispondeIntervista8(component,event);
     },
     rispondeIntervista9 : function(component,event,helper){
       helper.getRispondeIntervista9(component,event);
     },
     rispondeIntervista10 : function(component,event,helper){
       helper.getRispondeIntervista10(component,event);
     },
     rispondeIntervista11 : function(component,event,helper){
       helper.getRispondeIntervista11(component,event);
     },
     iniziaIntervista : function(component,event,helper){
       helper.getIniziaIntervista(component,event);
     },
     handlePrev : function(component,event,helper){
       helper.handlePrev(component,event);
     },
     terminataIntervista : function(component,event,helper){
      helper.getTerminataIntervista(component);
     },
     nonRisponde : function(component,event,helper){
        helper.getChoice(component,"New","Non risponde al telefono");
        helper.selectStepRisponde1NO(component);
     },
     irreperibile : function(component,event,helper){
       helper.getChoice(component,"Archived","Irreperibile");
     },
     nonAccetta : function(component,event,helper){
      helper.getChoice(component,"Archived","Non accetta");
     },
     rispondeQuezioneIntervista : function(component,event,helper){
      helper.getRispondeQuezioneIntervista(component,event);
     },
    concludiIntervista : function(component,event,helper){
        helper.getConcludiIntervista(component);
    }, 
})