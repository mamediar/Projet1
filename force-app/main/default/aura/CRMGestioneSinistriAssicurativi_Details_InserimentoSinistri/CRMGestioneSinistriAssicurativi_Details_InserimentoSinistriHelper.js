({
    
    recuperaAnagrafica : function(component, event){
        
        var msg='Filtri non sufficienti. Indicare una delle seguenti combinazioni:\n';
        var msg1='- Cognome, nome e data di nascita';
        var msg2='- Cognome, nome e codice fiscale';
        var msg3='- Ragione sociale';
        var msg4='- Codice cliente';
        var msg5='- Numero pratica';
        
        var nome = component.find('firstName').get('v.value');
        var cognome = component.find('lastName').get('v.value');
        var dataNascita = component.find('birthDate').get('v.value');
        var codiceFiscale = component.find('fiscalCod').get('v.value');
        var numeroPratica = component.find('numPratica').get('v.value');
        var codiceCliente = component.find('clientCod').get('v.value');
        var ragioneSociale = component.find('ragioneSociale').get('v.value');
        var pan = component.find('pan').get('v.value');
        
        var controlCheck = false;
        
        controlCheck = ((nome != undefined && nome.length > 0) && (cognome != undefined && cognome.length > 0) && (dataNascita != undefined && dataNascita.length > 0)) || controlCheck;
        controlCheck = ((nome != undefined && nome.length > 0) && (cognome != undefined && cognome.length > 0) && (codiceFiscale != undefined && codiceFiscale.length > 0)) || controlCheck;
        controlCheck = (numeroPratica != undefined && numeroPratica.length > 0) || controlCheck; 
        controlCheck = (ragioneSociale != undefined && ragioneSociale.length > 0) || controlCheck;
        controlCheck = (codiceCliente != undefined && codiceCliente.length > 0) || controlCheck;
        
        
        if(!controlCheck){
            this.showToast(msg.concat('\n'+msg1).concat('\n'+msg2).concat('\n'+msg3).concat('\n'+msg4).concat('\n'+msg5),'error');
            component.set('v.isPraticaFound',false);
            return;
        }
        component.set("v.spinner", true);
        var action = component.get("c.recuperaAnagraficaWS");
        action.setParams({ 
            nome : nome,
            cognome : cognome,
            dataNascita: dataNascita,
            codiceFiscale : codiceFiscale,
            numeroPratica : numeroPratica,
            codiceCliente : codiceCliente,
            ragioneSociale : ragioneSociale,
            pan:pan
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var lista = JSON.parse(response.getReturnValue());                   
                component.set("v.elencoPratiche", lista);
                if(lista != null && lista.length == 1){
                    component.set("v.pratica", lista[0]);
                    
                } 
                else if(lista == null || lista.length == 0){
                    this.showToast('La ricerca non ha restituito dati.','error'); 
                    component.set("v.pratica", null);
                }  
                    else{
                        component.set("v.pratica", null);
                    }
                
            }
            
            else if (state === "ERROR") {
                this.showToast('Si è verificato un errore.','error'); 
                
            }
            component.set("v.spinner", false);
            
        });
        $A.enqueueAction(action);
    },
    
    inserisci : function(component, event){
        var pratica = component.get("v.pratica");
        var tipologiaSinistro = component.get("v.tipologiaSinistro");
        var dataSinistro = component.get("v.dataSinistro");
        var note = component.get("v.note");
        
        if(tipologiaSinistro==''){
            this.showToast('Selezionare la tipologia.','error'); 
            return;
        }
         if(dataSinistro== undefined || dataSinistro == ''){
            this.showToast('Selezionare la data sinistro.','error'); 
            return;
        }
        var action = component.get("c.inserisciSinistroWS");
        component.set("v.spinner", true);
        
        console.log('Boris');
        console.log(JSON.stringify(pratica));
        
        action.setParams({ 
            assicurazione : pratica.assicurazione,
            numPratica : pratica.numPratica,
            tipoPratica: pratica.tipoPratica,
            dataSinistro : dataSinistro+'',
            tipoSinistro : tipologiaSinistro,
            note : note,
            cognome : pratica.cognome,
            nome : pratica.nome,
            dataNascita : pratica.dataNascita,
            luogoNascita:pratica.luogoNascita,
            cf : pratica.codFiscale,
            noteAss : pratica.noteAssicurazione,
            dataInizioCopertura : pratica.dataInizioCopertura,
            dataFineCopertura : pratica.dataFineCopertura
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stato = response.getReturnValue(); 
                if(stato == 0) this.showToast('Sinistro inserito','success'); 
                else if(stato == 1)this.showToast('Sinistro già esistente.','error'); 
                else if(stato == 2)this.showToast('La data del sinistro non può essere futura.','error'); 
                if(stato == 0 || stato == 1){
                    component.set("v.pratica", null);
                     component.set("v.note", null);
                     component.set("v.dataSinistro", null);
                    component.set("v.tipologiaSinistro","");

                }
            } 

            else if (state === "ERROR") {
                   var errors = response.getError();
                this.showToast('ERROR: '+errors[0].message,'error'); 
                
            }
            component.set("v.spinner", false);
            
        });
        $A.enqueueAction(action);
    },
        
    
    showToast : function(message, type){
        var toastEvent = $A.get("e.force:showToast");
        console.log(' message, type '+message+ ' - '+type);
        toastEvent.setParams({
            message: message,
            type : type
        });
        toastEvent.fire();
    }
    
})