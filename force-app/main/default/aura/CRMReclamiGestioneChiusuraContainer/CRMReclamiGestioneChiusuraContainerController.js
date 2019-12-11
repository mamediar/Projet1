({
    init:function(cmp,event,helper){
        console.log('init di chiusura');
        if(cmp.get('v.campiCase')){
            console.log('campi case valorizzato+----> setto i campi');
            helper.setFields(cmp);
        }
        var action=cmp.get('c.getInitValues');
        var tipoReclamo = cmp.get('v.campiCase.Tipo_Reclamo__c');
        action.setParam('idcase',cmp.get('v.campiCase'));
        console.log('CRMReclamiGestioneChiusuraContainerController.js -- INIT CAMPI CASE' + cmp.get('v.campiCase'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.ResponsabilitaList',resp.getReturnValue()['Responsabilita']);
                cmp.set('v.SocietaRecList',resp.getReturnValue()['SocietaRec']);
                cmp.set('v.SocietaAssList',resp.getReturnValue()['SocietaAss']);
                cmp.set('v.SicList',resp.getReturnValue()['Sic']);
                cmp.set('v.SicDettagli',resp.getReturnValue()['Sic']);
                cmp.set('v.AccoltoList',resp.getReturnValue()['accolto']);
                cmp.set('v.DecisioneList',resp.getReturnValue()['decisione']);
                cmp.set('v.InterventoAutList',resp.getReturnValue()['InterventoAut']);
                cmp.set('v.isTableLoading',false);  
                helper.setColumns(cmp);                
                if(tipoReclamo =='5446' ||tipoReclamo =='5409' || tipoReclamo =='5445'|| tipoReclamo =='5410'){
                    cmp.set('v.isInterventoAutorita',true);
                }
            }
        });
        cmp.set('v.isOk',helper.checkIfOkHelper(cmp));
        cmp.set('v.outputObj',helper.buildOutputObj(cmp));
        console.log('CRMReclamiGestioneChiusuraContainerController.js -- INIT OUTPUTOBJECT' + cmp.get('v.outputObj'));
        $A.enqueueAction(action);  
        
        if(cmp.get('v.abbuonoSelection') == false){
            cmp.set('v.abbuonoSelection','No');
            console.log('NO');   
        }
        else {
            cmp.set('v.abbuonoSelection','Si');
            console.log('Si');    
        }
        
        if(cmp.get('v.abbuonoSelection') == 'Si'){
            
            cmp.set('v.abbuonoValue',cmp.get('v.campiCase').Importo_Abbuono_Richiesta__c);
            
        }
        
       /*
        console.log('abbuono value === ' + cmp.get('v.abbuonoValue'));
        
        if(cmp.get('v.campiCase').Has_Rimborso__c == false){
            cmp.set('v.abbuonoSelection',1);
        	console.log('xxxxxx ' +cmp.get('v.abbuonoSelection'));
        }
        else{
            cmp.set('v.abbuonoSelection',0);
        	
        }
        */
    },
    
    handleChange:function(cmp,event,helper){
        
        cmp.set('v.isOk',helper.checkIfOkHelper(cmp));
        cmp.set('v.outputObj',helper.buildOutputObj(cmp));
        console.log('CRMReclamiGestioneChiusuraContainerController HANDLECHANGE ' + cmp.get('v.outputObj'));
        
    },
    
    getSelectedSic : function(cmp,event){
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.sicSelectedData',selectedRows);        
    },
    
    getSelectedAss : function(cmp,event){
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.assSelectedData',selectedRows);        
    },
    
    getSelectedSoc : function(cmp,event){
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.socSelectedData',selectedRows);        
    },
    
    getSelectedResp : function(cmp,event){
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.socSelectedData',selectedRows);        
    },
    
})