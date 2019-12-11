({
	getAutorizzazione : function(component, event, helper) {
        //Evento dalla GestioneRispostaLettera --> Padre
		var authorizzed = component.find("LetteraRispostaComponent");
        if(authorizzed != undefined && authorizzed != null)authorizzed.set("v.showButton", component.get("v.isAutorizzazioneOk"));
	},
    
    aggiorna : function(component, event, helper){

      var letteraRispostaComponent = component.find("LetteraRispostaComponent");
        if(letteraRispostaComponent!=undefined)letteraRispostaComponent.refresh();
    }
})