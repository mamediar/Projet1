({
	helperInit : function(cmp) 
    {
		var caseId = cmp.get('v.recordId');	
        var action = cmp.get("c.getRetentionList");
        action.setParams({
            "caseId": caseId
        });
                
        cmp.set("v.retentionTableColumns", [
            {label: 'Numero Carta', fieldName: 'LoanNumber__c', type: 'text' ,height:50},
            {label: 'Prodotto Attribuito',fieldName:'ProductDescription__c', type:'text'},
            {label: 'Prodotto Carta',fieldName:'ProductCode__c', type:'text'},
            {label: 'Stato Carta',fieldName:'LoanStatus__c', type:'text'},
            {label: 'Blocco Carta',fieldName:'LoanStatusAttribute__c', type:'text'},
            {label: 'Esito Retention',fieldName:'Action__c', type:'text'},
            {label: 'Valore Retention',fieldName:'RetentionValue__c', type:'text'},
            {label: 'Carta Selezionata',fieldName:'Selected__c', type:'boolean'},
            {label: 'Revoca',fieldName:'dispositionName', type:'text',initialwidth:50},
            {label: 'Esito Gestione',fieldName:'Gestione_temp', type:'text'}
        ]);
        cmp.set("v.radioGroupOption", [
            {'label': 'SI', 'value': 'true' } ,
            {'label': 'NO', 'value': 'false' }
        ]);
        cmp.set("v.radioGroupOptionRevoca",[
            {'label': 'NO', 'value': 'NO' } ,
            {'label': 'SI, a Saldo', 'value': 'A SALDO' } ,
            {'label': 'SI, Rateale con saldo zero', 'value': 'RATEALE NULLO' } ,
            {'label': 'SI, Rateale saldo positivo','value':'RATEALE POSITIVO'}
        ]);
        cmp.set("v.radioGroupOptionConsenso",[
            {'label': 'Si' , 'value' : 'true'},
            {'label': 'No', 'value': 'false'}
        ])
        action.setCallback(this, function(response) 
        {
            if ( response.getState() == 'SUCCESS' ) 
            {
                var wrapObject = response.getReturnValue();
                console.log(JSON.stringify(wrapObject));
                var retentionList = wrapObject.retentionList;
                var scriptList = wrapObject.scriptList;
                var clientAccount = wrapObject.clientAccount;
                var scriptAlertText;
                var scriptAlertName = wrapObject.scriptAlertName;
                var scriptGenericName = wrapObject.scriptGenericName;
                for(var i=0;i<scriptList.length;i++)
                {
                      if(scriptList[i].Name == scriptAlertName)
                    {
                        
                        scriptAlertText = scriptList[i];
                       
                    }
                }
                for(var i=0;i<retentionList.length;i++)
                        {
                           	if(retentionList[i].Action__c === undefined || retentionList[i].Action__c == null )
                            {
                               retentionList[i].Action__c = ''; 
                            }
                            retentionList[i].selectRegistration = '';
                            retentionList[i].tempRevoca = (retentionList[i].Disposition__c === undefined || retentionList[i].Disposition__c == null ) ? "" : retentionList[i].Disposition__r.Visibility__c;
                            retentionList[i].Gestione_temp = (retentionList[i].Action__c == 'KO' || retentionList[i].Action__c == '' )? 'La carta è già stata gestita dal primo operatore.' : '';
                            retentionList[i].tipoRateale = '';
                            retentionList[i].dispositionName = (retentionList[i].Disposition__c === undefined || retentionList[i].Disposition__c == null ) ? "" : retentionList[i].Disposition__r.Name ;
                        	retentionList[i].Disposition__c = (retentionList[i].Disposition__c === undefined || retentionList[i].Disposition__c == null ) ? "" : retentionList[i].Disposition__c ;
                        
                        }
                cmp.set('v.retentionList', retentionList);
                cmp.set('v.scriptList',scriptList);
                cmp.set('v.scriptAlert',scriptAlertText);
                cmp.set('v.scriptGenericName',scriptGenericName);
                cmp.set('v.customer',clientAccount);
            }
        });
        $A.enqueueAction(action);
	}
})