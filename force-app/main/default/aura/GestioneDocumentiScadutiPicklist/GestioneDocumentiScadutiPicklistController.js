({
	doNext : function(component, event, helper) {
        console.log("Evento intercettato" + event.getParam('disposition').External_Id__c);
       	
		component.set('v.disposition',event.getParam('disposition'));
         console.log("notavalue    : " + event.getParam('note'));
        
       component.set('v.attrProva',event.getParam('note'));
        
        var navigate = component.get('v.navigateFlow');
        
       //navigate("NEXT");
    }       
})