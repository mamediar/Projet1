({
    
    //Boris Inizio
    init : function(component, event){
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();
        
        var action = component.get("c.getProvinceCitta");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS" ) {
                component.set("v.provinciaCitta",JSON.parse(response.getReturnValue()));
                if(component.get("v.cittaSelezionata")!= '')this.getCitta(component, event);
            }
            else if (response.getState() == "ERROR" ) {
                alert("ERRORE: Provincie non caricate");
            }
           spinner.decreaseCounter();
        });
        $A.enqueueAction(action);        
    },
    
    getCitta : function(component, event){
        
        var provinciaByEvent= event.getSource().get("v.value") == undefined ? component.get("v.provinciaSelezionata") : event.getSource().get("v.value");
        var provinciaCitta = component.get("v.provinciaCitta");
           
        var i=0;
        for(; i<provinciaCitta.length;i++) if(provinciaCitta[i].identificativo == provinciaByEvent) break;
        console.log(provinciaCitta);
        if(provinciaCitta[i]==undefined || provinciaCitta[i].citta.length == 0){//Faccio la chiamata al server
            var spinner = component.find('spinnerComponent');
        	spinner.incrementCounter();
            
            var action = component.get("c.getCittaFromEvent");
            var provJson = JSON.stringify(provinciaCitta);
            action.setParams({
                provincia : provinciaByEvent,
                provinciaCitta : provJson
            });
            action.setCallback(this, function(response) {
                if (response.getState() == "SUCCESS" ) {
                    component.set("v.listaCitta",JSON.parse(response.getReturnValue()));
                    var proxy = component.get("v.provinciaCitta");
                    for(var i=0;i<proxy.length;i++){
                        if(proxy[i].identificativo == provinciaByEvent || proxy[i].provincia == provinciaByEvent){
                            proxy[i].citta = component.get("v.listaCitta");
                            break;
                        }
                    }
                }
                else if (response.getState() == "ERROR" ) {
                      var errors = response.getError();
                    component.set("v.test",errors[0].message);
                }
              
                spinner.decreaseCounter();
            });
            console.log('Checkpoint 2');
            
            $A.enqueueAction(action);  
               console.log('Checkpoint 3');
        }
        // ELSE L'ho precedentemente chiamato, utilizzo la cache
        else{
             component.set("v.listaCitta",provinciaCitta[i].citta);
        }
    }
    
    
    //Boris Fine
    
  
})