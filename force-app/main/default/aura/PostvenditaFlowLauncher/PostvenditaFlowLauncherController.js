({
	doInit : function(cmp) {
        var listTipologia = [{label: '', value: null}];
        var action = cmp.get("c.loadListaTipologia");
        action.setCallback(this, function(response) {
                    
            var state = response.getState();
            if (state === "SUCCESS") {
                var list = response.getReturnValue() ;
                  list.forEach(function(element) {
                      listTipologia.push({label:element.Label, value:element.Label});
                  });
                cmp.set("v.listTipologia", listTipologia);
            }                   
        });                	
        $A.enqueueAction(action);
	},
    
    selezionaTipologia : function(cmp){
        var action = cmp.get("c.loadListaSottotipologia");
        var tipologiaSelezionata = cmp.get("v.tipologiaSelezionata");
        action.setParams({
            "tipologiaSelezionata": tipologiaSelezionata
        });
        
        action.setCallback(this, function(response) {
                    
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.listSottotipologia", response.getReturnValue());
            }                   
        });                	
        $A.enqueueAction(action);
	},
    
    lanciaFlowPostvendita : function(cmp){
        
        var sottotipologia = cmp.get("v.listSottotipologia")[cmp.get("v.sottotipologiaSelezionata")];
        
        var action = cmp.get("c.loadSottotipologiaAttribute");
        action.setParams({
            "pvc": sottotipologia
        });
        
        var sottotipologiaPrms = {};
        action.setCallback(this, function(response) {
                    
            var state = response.getState();
            if (state === "SUCCESS") {
                sottotipologiaPrms = response.getReturnValue() ;
                console.log(sottotipologiaPrms);
                cmp.set("v.visibilityComboPV", false);
                
                var accountId = cmp.get('v.utenteSelezionato');
                var accountId = accountId == null? '' : accountId;
        
                var inputVariables = [
                    {name: 'tipologiaSelezionata', type:'String', value:cmp.get("v.tipologiaSelezionata")},
                    {name: 'sottotipologiaSelezionata', type:'String', value:sottotipologia.Label},
                    {name: 'QueueId', type:'String', value:sottotipologiaPrms.QueueNameId},
                    {name: 'RecordTypeId', type:'String', value:sottotipologiaPrms.RecordTypeId},
                    {name: 'Subject', type:'String', value:sottotipologiaPrms.Subject},
                	{name: 'accountId', type:'String', value:accountId}];
                
                var theflow = cmp.find("theflow");
                theflow.startFlow(sottotipologiaPrms.FlowName, inputVariables);
            }                   
        });                	
        $A.enqueueAction(action);
    }
    
})