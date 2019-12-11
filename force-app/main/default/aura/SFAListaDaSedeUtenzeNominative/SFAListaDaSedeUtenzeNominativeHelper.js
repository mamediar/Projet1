({
    
    callPDFAddProposto: function (component, event) {
		var action = component.get("c.getPDFAddendumPropostaGDO");
        var caseSel = component.get('v.caseChildSelected');
        var idDealer = (caseSel.AccountId != null && caseSel.AccountId != 'undefined') ? caseSel.AccountId : caseSel.Branch__c;
		console.log('idDealer:'+idDealer);
        action.setParams({
			//delearId: '0015E00000osmeVQAQ'
			delearId: idDealer 
        }); 
        this.loadSpinner(component);
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var results = response.getReturnValue();
                
                //intese statiche
                var pdfRecuperato = component.get("v.pdfRecuperato");      
                if (pdfRecuperato==null) {
                    pdfRecuperato = [];
                }          
                var base64 = results.base64;
                var namePdf = results.name;
                pdfRecuperato.push({value:base64, key:namePdf});
                console.log('base64: '+base64);
                component.set("v.pdfRecuperato",pdfRecuperato); 
            } else {
                console.log('chiamata non success');
            }
          
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        
    },
    callPDFAccettato: function (component, event) {
		var action = component.get("c.getPDFAddendumAccettazioneGDO");
		var caseSel = component.get('v.caseChildSelected');
		var idDealer = (caseSel.AccountId != null && caseSel.AccountId != 'undefined') ? caseSel.AccountId : caseSel.Branch__c;
        action.setParams({
			//delearId: '0015E00000osmeVQAQ'
			delearId: idDealer 
        }); 
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var results = response.getReturnValue();
                
                //intese statiche
                var pdfRecuperato = component.get("v.pdfRecuperato");      
                if (pdfRecuperato==null) {
                    pdfRecuperato = [];
                }          
                var base64 = results.base64;
                var namePdf = results.name;
                pdfRecuperato.push({value:base64, key:namePdf});
                console.log('base64: '+base64);
                component.set("v.pdfRecuperato",pdfRecuperato); 
            } else {
                console.log('chiamata non success');
            }
          
            
        });
        $A.enqueueAction(action);
        
    },
	callPDFElencoIncaricati: function (component, event) {
        var action = component.get("c.getBase64PDFElencoIncaricati");
        var caseSel = component.get('v.caseChildSelected');
		console.log('caseSel:'+caseSel);
        action.setParams({
			IdCase: caseSel.Id 
        }); 
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var results = response.getReturnValue();
                console.log('chiamata success:'+results);
                //intese statiche
                component.set("v.bodybase",results); 
            } else {
                console.log('chiamata non success');
            }
        });
        $A.enqueueAction(action);      
    },
    parseBase64toFile : function(component, event,base64) {
        
        var url = 'data:application/octet-stream;base64,' + base64;
        var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    },
    loadSpinner : function(component, event, helper) {
        console.log('showSpinner');
        component.set("v.showSpinner", true);
    },
    
    hideSpinner : function(component, event, helper) {
        component.set("v.showSpinner", false);
        console.log('hideSpinner');
    }
        
})