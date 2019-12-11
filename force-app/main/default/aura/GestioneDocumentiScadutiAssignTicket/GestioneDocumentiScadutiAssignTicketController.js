({
    init : function(component, event, helper) 
    {
        component.set('v.columns',[
            {label:'Codice Case',fieldName:'CaseNumber',type:'text',initialWidth:150},
            {label:'Oggetto',fieldName:'Subject',type:'text',initialWidth:300},
            {label:'Cognome',fieldName:'AccountLastName',type:'text',initialWidth:200},
            {label:'Nome',fieldName:'AccountFirstName',type:'text',initialWidth:200},
            {label:'Codice Fiscale',fieldName:'AccountCodiceFiscale',type:'text',initialWidth:200},
            {label:'Data di Nascita',fieldName:'AccountDataNascita',type:'date',initialWidth:150}
        ]);
        console.log("TEST DI PROVA");
    },
    SearchCustomer : function(component, event, helper) 
    {
        console.log(component.get('v.firstName'));
        console.log(component.get('v.lastName'));
        console.log(component.get('v.fiscalCode'));
        console.log(component.get('v.dataNascita'));
        var action=component.get("c.returnTicket");
        action.setParams({'nome':component.get('v.firstName'),'cognome': component.get('v.lastName'),'Codicefiscale':component.get('v.fiscalCode'),'Datadinascita':component.get('v.dataNascita')});
        action.setCallback(this,function(response){
            if (response.getState() == 'SUCCESS'){                    
                var result = response.getReturnValue();
                console.log(JSON.stringify(result));
                for (var i = 0; i<result.length;i++){
                    if(result[i].Account)
                    {
                        result[i].AccountFirstName = result[i].Account.FirstName;
                        result[i].AccountLastName = result[i].Account.LastName;
                        result[i].AccountCodiceFiscale = result[i].Account.Codice_Fiscale__pc;
                        result[i].AccountDataNascita = result[i].Account.Data_Nascita__c;
                    }    
                }
                component.set('v.datiTabella',result);
            }
        }); 
        $A.enqueueAction(action);        
    },
    selectContact : function(component, event, helper)
    {
        var valore=event.getParam('selectedRows')[0];
        console.log(valore);
        component.set('v.contattoSelezionato',valore);
        console.log(JSON.stringify(component.get('v.contattoSelezionato')));
        
    },
    abbinaContact : function(component, event, helper)
    {     
        var action = component.get("c.abbinaContatto");
        action.setParam('caseDadId',component.get('v.recordId'));
        action.setParam('caseChildId',component.get('v.contattoSelezionato.Id'));
        action.setParam('disposition',component.get('v.disposition'));
        action.setParam('notas',component.get('v.notaAssign'));
        
        action.setCallback(this,function(response){
            if (response.getState() == 'SUCCESS'){  
                
                var action2 = component.get("c.chiamaServizio");
                var lista = response.getReturnValue();
                action2.setParam('strings',lista);
                component.set('v.idcliente',lista[2]);
                
                console.log(JSON.stringify(lista));
                console.log('v.idclienteCallback = ' + component.get('v.idcliente'));
                
                $A.enqueueAction(action2);
                var navigate = component.get('v.navigateFlow');
                setTimeout(function(){navigate("FINISH");}, 200);
            }
        });
         console.log('v.idcliente = ' + component.get('v.idcliente'));
        $A.enqueueAction(action);
        console.log('v.idclienteDopotutto = ' + component.get('v.idcliente'));
          //setTimeout(function(){navigate("NEXT");}, 400);
       
        
    }
    
})