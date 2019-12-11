({
	helperMethod : function() {
		
	},
    
    recuperaEstrattoConto: function(cmp, event, helper) {

        var base64;
        var codClienteComp = cmp.get("v.codCliente");
        var numeroPraticaComp = cmp.get("v.numeroPratica");
        var annoComp = cmp.get("v.anno");
        var meseComp = cmp.get("v.mese");
        console.log('DP codClienteComp: '+codClienteComp);
        console.log('DP numeroPraticaComp: '+numeroPraticaComp);
        console.log('DP annoComp: '+annoComp);
        console.log('DP meseComp: '+meseComp);
        var cd = codClienteComp != null ? codClienteComp : '';
        var np = numeroPraticaComp != null ? numeroPraticaComp : '';
        var an = annoComp != null ? annoComp : '';
        var me = meseComp != null ? meseComp : '';
        
        if(cd!='' && np!='' && an!='' && me!=''){
        	if (isNaN(an) || isNaN(me)){
            	this.showToast('Anno e Mese devono essere numerici.','error'); 
                return;
            }
            if (isNaN(cd) || isNaN(np)){
            	this.showToast('Codice Cliente e N°pratica non devono contenere caratteri.','error'); 
                return;
            }
        	var action = cmp.get("c.getContoPDF");
                this.showSpinner(cmp, event);
                action.setParams({
                    codCliente : codClienteComp,
                    numPratica : numeroPraticaComp,
                    anno : annoComp,
                    mese : meseComp
                });            
                action.setCallback(this, function(data) {
                    var state = data.getState();            
                    if(state == "SUCCESS"){
                        var retVal = data.getReturnValue(); 
                        try{
                            base64 = retVal.recuperaEstrattoContoPDFResponse.stream;
                        } catch (e) {
                            console.error('error ' + e);
                            this.showToast('Errore: '+e,'error');
                            this.hideSpinner(cmp, event);
                            return;
                        }

                        if(base64!=' '){
                        
                            cmp.set("v.Pdfavailable",true);
                            cmp.set("v.NameFile",'Cliente - '+cd+' - '+np+' Periodo - '+me+'/'+an+'.pdf');                           
                            var url = 'data:application/octet-stream;base64,' + base64;
                            var urlEvent = $A.get('e.force:navigateToURL');                       
                            cmp.set("v.UrlPdf",url);                                                 
                            this.showToast('PDF ricevuto.','success');
                        }else{
                            cmp.set("v.Pdfavailable",false);
                            this.showToast('La ricerca non ha restituito risultati.','warning');
                            this.hideSpinner(cmp, event);
                            return;
                        }
    
                    }else if(state == "ERROR"){
                        this.showToast('Errore nella chiamata al servizio.','error');
                        cmp.set("v.Pdfavailable",false);
                        
                    }
                    this.hideSpinner(cmp, event);                   
                });
                $A.enqueueAction(action); 
                                                
            	
        }else{
        	this.showToast('Tutti i campi sono obbligatori per la ricerca.','error');
            cmp.set("v.Pdfavailable",false);
        }
                
    },
    
    showToast : function(message, type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type : type
		});
		toastEvent.fire();
	},
    
    showSpinner: function(cmp, event) {         
        cmp.set("v.spinner", true); 
    },
     
    hideSpinner : function(cmp, event){            
        cmp.set("v.spinner", false);
    },
})